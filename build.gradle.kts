import java.text.SimpleDateFormat
import java.util.Date
import java.io.PrintStream

import org.qt4cg.gradle.*

plugins {
  id("java")
  id("org.qt4cg.gradle.xslt")
  id("org.qt4cg.gradle.dtd-validate")
  id("org.qt4cg.gradle.xsd-validate")
  id("org.qt4cg.gradle.html-fixup")
  id("org.qt4cg.gradle.redirect")
}

repositories {
  mavenLocal()
  mavenCentral()
  maven { url = uri("https://dev.saxonica.com/maven") }
}

val transform = configurations.create("transform") {
  extendsFrom(configurations["implementation"])
}

val validate = configurations.create("validate") {
  extendsFrom(configurations["implementation"])
}

val saxonVersion = project.findProperty("saxonVersion") as String

dependencies {
  implementation("com.saxonica:Saxon-EE:${saxonVersion}")
  implementation(files("lib/xjparse-3.1.0.jar"))
}

val debugTransformations = project.findProperty("debugTransformations") == "true"
val pedanticBuild = project.findProperty("pedantic") == "true"

configure<XsltExtension> {
  configuration = configurations["transform"]
  debug = debugTransformations
  // This is a bit of a hack since it's going to pass pedantic=true
  // to *all* stylesheet invocations, not just the spec transformation,
  // but passing extra parameters is generally harmless
  if (pedanticBuild) {
    defaultParameters = mapOf("pedantic" to "true")
  }
}

configure<HtmlFixupExtension> {
  configuration = configurations["transform"]
  debug = false
}

configure<DtdValidateExtension> {
  configuration = configurations["validate"]
  debug = false
}

configure<XsdValidateExtension> {
  configuration = configurations["validate"]
  debug = true
}

defaultTasks("publish", "grammarExplorer")

tasks.register("publish") {
  dependsOn("publish-xpath-functions-40",
            "publish-xquery-40",
            "publish-xslt-40",
            "publish-xslt-streaming-40",
            "publish-datamodel-40",
            "publish-xslt-xquery-serialization-40",
            "publish-expath-40")
  inputs.dir(layout.buildDirectory.dir("www"))
  outputs.file(layout.buildDirectory.dir("www/index.html"))

  doLast {
    val now = Date()
    val index = PrintStream(layout.buildDirectory.file("www/index.html").get().asFile)
    index.println("<!DOCTYPE html>")
    index.println("<html xmlns='http://www.w3.org/1999/xhtml'>")
    index.println("<head>")
    index.println("<meta charset='utf-8' />")
    index.println("<title>QT4CG index page</title>")
    index.println("<style>html { font-size: 16pt }</style>")
    index.println("</head>")
    index.println("<body>")
    index.println("<h1>Index</h1>")
    index.print("<p>Published ")
    index.print(SimpleDateFormat("dd MMM yyyy").format(Date()).toString())
    index.print(" at ")
    index.print(SimpleDateFormat("HH:mm:ss").format(Date()).toString())
    index.println(".</p>")
    
    index.println("<ul>")

    val www = layout.buildDirectory.file("www").get().asFile
    val indexes = mutableListOf<String>()
    for (file in www.listFiles().sorted()) {
      val pos = Math.max(file.toString().indexOf("/www/"),file.toString().indexOf("\\www\\"))
      val path = file.toString().substring(pos+5)
      if (File("${file}/Overview.html").exists()) {
        index.println("<li><a href='${path}/Overview.html'>${path}</a></li>")
      } else if (File("${file}/xpath-40.html").exists()) {
        index.println("<li><a href='${path}/xpath-40.html'>xpath-40</a></li>")
        index.println("<li><a href='${path}/xquery-40.html'>xquery-40</a></li>")
      }
    }

    index.println("</ul>")

    if (www.resolve("grammar-explorer").exists()) {
      index.println("<p>The <a href='grammar-explorer/index.html'>grammar explorer</a>")
      index.println("is also available.</p>")
    }

    index.println("</body>")
    index.println("</html>")
    index.close()
  }
}

tasks.register("publish-xquery-40") {
  dependsOn("xquery_40", "xpath_40")
}

tasks.register("publish-xpath-40") { // same as publish-xquery-40
  dependsOn("xquery_40", "xpath_40")
}

tasks.register("publish-xpath-functions-40") {
  dependsOn("xpath_functions_40", "xpath_keyword_tests")
}

tasks.register("publish-xslt-40") {
  dependsOn("xslt_40")
}

tasks.register("publish-xslt-streaming-40") {
  dependsOn("xslt_streaming_40")
}

tasks.register("publish-datamodel-40") {
  dependsOn("datamodel_40")
}

tasks.register("publish-xslt-xquery-serialization-40") {
  dependsOn("serialization_40")
}

// ============================================================

tasks.register<Exec>("qt4tests") {
  description = "Make sure the qt4tests repository is available"
  
  doFirst {
    mkdir(layout.buildDirectory)
  }

  if (layout.buildDirectory.file("qt4tests").get().asFile.exists()) {
    workingDir(layout.buildDirectory.file("qt4tests"))
    commandLine("git", "pull")
  } else {
    workingDir(layout.buildDirectory)
    commandLine("git", "clone", "https://github.com/qt4cg/qt4tests.git")
  }
}

tasks.register("saxon_config") {
  inputs.dir(layout.projectDirectory.dir("lib"))
  outputs.file(layout.buildDirectory.file("config.xml"))

  doLast {
    val cfg = PrintStream(layout.buildDirectory.file("config.xml").get().asFile)
    cfg.println("<configuration xmlns='http://saxon.sf.net/ns/configuration'")
    cfg.println("               edition='EE'")

    val lic = layout.projectDirectory.file("lib/saxon-license.lic").asFile
    if (lic.exists()) {
      cfg.println("               licenseFileLocation='${lic}'/>")
    } else {
      cfg.println("/>")
    }
    cfg.close()
  }
}

if (layout.projectDirectory.file("lib/saxon-license.lic").asFile.exists()) {
  tasks.register<XsltTransform>("fo_generate_tests") {
    dependsOn("qt4tests", "saxon_config")
    source = layout.projectDirectory.file("specifications/xpath-functions-40/src/function-catalog.xml")
    stylesheet = layout.projectDirectory.file(
        "specifications/xpath-functions-40/style/generate-qt3-test-set.xsl")
    result = layout.buildDirectory.file("test-suite/app/fo-spec-examples.xml")
    options = listOf("-val")
    dtdValidate = false
  }
} else {
  tasks.register("fo_generate_tests") {
    doLast {
      println("Cannot generate tests from specification; no Saxon license available.")
    }
  }
}

// ============================================================
// EXPath modules

tasks.register("publish-expath-40") {
  dependsOn("binary_40", "file_40")
}

for (shortName in listOf("binary", "file")) {
  val specName = if ("$shortName" == "binary") "BIN40" else "FILE40"

  tasks.register<XsdValidate>("validate_${shortName}_function_catalog") {
    source = layout.projectDirectory.file("specifications/expath-${shortName}/src/function-catalog.xml")
    schema = layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.scm")
    result = layout.buildDirectory.file("tmp/valid/${shortName}-catalog.marker")
  }

  tasks.register("${shortName}_40") {
    dependsOn("${shortName}_xml", "${shortName}_html",
              "validate_${shortName}_function_catalog",
              "${shortName}_resources", "${shortName}_generate_tests")
    group = "Specifications"
    description = "Build the EXPath ${shortName} 4.0 specification"
  }
  
  tasks.register<XsltTransform>("etc_${specName}") {
    dependsOn("${shortName}_merge", "saxon_config")
    source = layout.buildDirectory.file("expanded/${shortName}/${shortName}-functions-40.xml")
    stylesheet = layout.projectDirectory.file("style/extract.xsl")
    result = layout.buildDirectory.file("etc/${specName}.xml")
    parameters = mapOf(
        "specdoc" to specName,
        "uri" to "https://qt4cg.org/specifications/expath-${shortName}-40/")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("${shortName}_merge") {
    dependsOn("common_sources", "saxon_config")
    description = "Expand the EXPath ${shortName} sources into a single XML file"
    source = layout.projectDirectory.file("specifications/expath-${shortName}/src/${shortName}-functions.xml")
    stylesheet = layout.projectDirectory.file(
        "specifications/xpath-functions-40/style/merge-function-specs.xsl")
    result = layout.buildDirectory.file("expanded/${shortName}/${shortName}-functions-40.xml")
  }

  tasks.register<XsltTransform>("${shortName}_xml") {
    dependsOn("${shortName}_merge", "saxon_config")
    group = "Spec XML"
    description = "Create the XML version of the specification"
    source = layout.buildDirectory.file("expanded/${shortName}/${shortName}-functions-40.xml")
    stylesheet = layout.projectDirectory.file("style/identity.xsl")
    result = layout.buildDirectory.file("www/expath-${shortName}-40/${shortName}-40.xml")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("_${shortName}_html") {
    dependsOn("${shortName}_merge", "setup_crossref_indexes", "saxon_config")
    source = layout.buildDirectory.file("expanded/${shortName}/${shortName}-functions-40.xml")
    stylesheet = layout.projectDirectory.file("specifications/expath-${shortName}/style/expath-functions.xsl")
    result = layout.buildDirectory.file("www/expath-${shortName}-40/Overview.xml")
    dtdValidate = false
  }

  tasks.register<HtmlFixup>("${shortName}_html") {
    dependsOn("_${shortName}_html", "${shortName}_resources")
    group = "Spec HTML"
    description = "Create the HTML and XHTML versions of the specification"
    source = layout.buildDirectory.file("www/expath-${shortName}-40/Overview.xml")
    result = layout.buildDirectory.file("www/expath-${shortName}-40/Overview.html")
  }

  tasks.register<Copy>("_${shortName}_resources_catalog") {
    into(layout.buildDirectory.file("www/expath-${shortName}-40"))
    from(layout.projectDirectory.file("specifications/expath-${shortName}/src")) {
      include("function-catalog.xml")
    }
  }

  tasks.register<Copy>("_${shortName}_resources_css") {
    into(layout.buildDirectory.file("www/expath-${shortName}-40/css"))
    from(layout.projectDirectory.file("specifications/css")) {
      include("w3c-base.css")
      include("qtspecs.css")
      include("xpath-functions-40.css")
    }
  }

  tasks.register<Copy>("_${shortName}_resources_js") {
    into(layout.buildDirectory.file("www/expath-${shortName}-40/js"))
    from(layout.projectDirectory.file("specifications/js")) {
      include("fo-datalist.js")
      include("toc.js")
    }
  }

  tasks.register<Redirect>("${shortName}_resources") {
    dependsOn("_${shortName}_resources_catalog",
              "_${shortName}_resources_css",
              "_${shortName}_resources_js")
    index = layout.buildDirectory.file("www/expath-${shortName}-40/index.html")
  }

  if (layout.projectDirectory.file("lib/saxon-license.lic").asFile.exists()) {
    tasks.register<XsltTransform>("${shortName}_generate_tests") {
      dependsOn("qt4tests", "saxon_config")
      source = layout.projectDirectory.file("specifications/expath-${shortName}/src/function-catalog.xml")
      stylesheet = layout.projectDirectory.file("style/generate-test-set.xsl")
      result = layout.buildDirectory.file("test-suite/app/${shortName}-spec-examples.xml")
      options = listOf("-val")
      dtdValidate = false
    }
  } else {
    tasks.register<XsltTransform>("${shortName}_generate_tests") {
      doLast {
        println("Cannot generate tests from specification; no Saxon license available.")
      }
    }
  }
}

// ============================================================

tasks.register<JavaExec>("validate_xpath_functions_function_catalog") {
  inputs.file(layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.scm"))
  inputs.file(layout.projectDirectory.file("specifications/xpath-functions-40/src/function-catalog.xml"))

  classpath = configurations["transform"]
  mainClass = "com.saxonica.Validate"
  args("-xsd:${layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.scm")}",
       "-s:${layout.projectDirectory.file("specifications/xpath-functions-40/src/function-catalog.xml")}")
}

tasks.register("xpath_functions_40") {
  group = "Specifications"
  description = "Build the XPath Functions and Operators 4.0 specification"
  dependsOn("validate_xpath_functions_function_catalog",
            "fo_xml", "fo_html", "fo_resources", "fo_generate_tests")
}

tasks.register<Copy>("common_sources") {
  into(layout.buildDirectory.dir("image-sources"))
  from(layout.projectDirectory.dir("specifications/image-sources")) {
    include("*.xml")
  }
}

tasks.register<XsltTransform>("fo_merge") {
  dependsOn("common_sources", "saxon_config")
  description = "Expand the FO sources into a single XML file"
  source = layout.projectDirectory.file("specifications/xpath-functions-40/src/xpath-functions.xml")
  stylesheet = layout.projectDirectory.file("specifications/xpath-functions-40/style/merge-function-specs.xsl")
  result = layout.buildDirectory.file("expanded/xpath-functions-40/xpath-functions-40.xml")
}

tasks.register<XsltTransform>("fo_xml") {
  dependsOn("fo_merge", "saxon_config")
  group = "Spec XML"
  description = "Create the XML version of the specification"

  source = layout.buildDirectory.file("expanded/xpath-functions-40/xpath-functions-40.xml")
  stylesheet = layout.projectDirectory.file("style/identity.xsl")
  result = layout.buildDirectory.file("www/xpath-functions-40/xpath-functions-40.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_fo_html") {
  dependsOn("fo_merge", "setup_crossref_indexes", "saxon_config")
  group = "Spec HTML"
  description = "Create the HTML and XHTML versions of the specification"
  source = layout.buildDirectory.file("expanded/xpath-functions-40/xpath-functions-40.xml")
  stylesheet = layout.projectDirectory.file("specifications/xpath-functions-40/style/xpath-functions.xsl")
  result = layout.buildDirectory.file("www/xpath-functions-40/Overview.xml")
  dtdValidate = false
}

tasks.register<HtmlFixup>("fo_html") {
  dependsOn("_fo_html", "fo_resources")
  source = layout.buildDirectory.file("www/xpath-functions-40/Overview.xml")
  result = layout.buildDirectory.file("www/xpath-functions-40/Overview.html")
}

tasks.register<Copy>("_fo_resources_src") {
  into(layout.buildDirectory.dir("www/xpath-functions-40"))
  from(layout.projectDirectory.dir("specifications/xpath-functions-40/src")) {
    include("analyze-string.xsd")
    include("schema-for-json.xsd")
    include("function-catalog.xml")
  }
}

tasks.register<Copy>("_fo_resources_css") {
  into(layout.buildDirectory.dir("www/xpath-functions-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xpath-functions-40.css")
  }
}

tasks.register<Copy>("_fo_resources_js") {
  into(layout.buildDirectory.dir("www/xpath-functions-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("fo-datalist.js")
    include("toc.js")
  }
}

tasks.register<Redirect>("fo_resources") {
  dependsOn("_fo_resources_src", "_fo_resources_css", "_fo_resources_js")
  description = "Copy static resources for publication"
  index = layout.buildDirectory.file("www/xpath-functions-40/index.html")
}

tasks.register<XsltTransform>("xpath_keyword_tests") {
  dependsOn("saxon_config")
  group = "Test suite"
  description = "Create the BuiltInKeywords.xml tests"
  source = layout.projectDirectory.file("specifications/xpath-functions-40/src/function-catalog.xml")
  stylesheet = layout.projectDirectory.file(
      "specifications/xpath-functions-40/style/generate-keyword-test-set.xsl")
  result = layout.buildDirectory.file("test-suite/misc/BuiltInKeywords.xml")
  dtdValidate = false
}

// ============================================================

tasks.register<XsltTransform>("grammar_40") {
  dependsOn("saxon_config")

  // This is a tiny bit complicated because I only want to validate once
  // each time the grammar changes and in order to get Gradle to do that
  // I have to have an input and an output; so I copy it to build and
  // then validate it.

  source = layout.projectDirectory.file("specifications/grammar-40/xpath-grammar.xml")
  stylesheet = layout.projectDirectory.file("style/grammar-identity.xsl")
  result = layout.buildDirectory.file("grammar-40/xpath-grammar.xml")
}

// ============================================================

tasks.register<XsdValidate>("validate_xslt_function_catalog") {
  source = layout.projectDirectory.file("specifications/xslt-40/src/function-catalog.xml")
  schema = layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.scm")
  result = layout.buildDirectory.file("tmp/valid/xslt-function-catalog.marker")
}

tasks.register("xslt_40") {
  group = "Specifications"
  description = "Build the XSLT 4.0 specification"
  dependsOn("xslt_grammar", "xslt_merge_catalog", "xslt_resources",
            "validate_xslt_function_catalog", "xslt_html", "xslt_xml")
}

tasks.register<XsltTransform>("_strip_xslt_grammar") {
  dependsOn("grammar_40", "saxon_config")
  inputs.dir(layout.projectDirectory.dir("style"))
  inputs.dir(layout.projectDirectory.dir("specifications/xslt-40/src"))
  inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/src"))
  inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/style"))
  inputs.dir(layout.projectDirectory.dir("specifications/grammar-40"))

  source = layout.buildDirectory.file("grammar-40/xpath-grammar.xml")
  stylesheet = layout.projectDirectory.file("specifications/grammar-40/parser/strip.xsl")
  result = layout.buildDirectory.file("xslt-40/temp-xslt40-grammar.xml")
  parameters = mapOf("spec1" to "xslt40-patterns")
  dtdValidate = false
}

tasks.register<XsltTransform>("_tokens_xslt_grammar") {
  dependsOn("_strip_xslt_grammar")
  source = layout.buildDirectory.file("xslt-40/temp-xslt40-grammar.xml")
  stylesheet = layout.projectDirectory.file("style/extract-tokens.xsl")
  result = layout.buildDirectory.file("xslt-40/tokens-with-dups.xml")
  parameters = mapOf(
      "spec" to "xslt40",
      "grammar-file"
        to "${layout.buildDirectory.file("xslt-40/temp-xslt40-grammar.xml").get().asFile.toURI()}")
  dtdValidate = false
}

tasks.register<XsltTransform>("_elimdup_xslt_grammar") {
  dependsOn("_tokens_xslt_grammar")
  source = layout.buildDirectory.file("xslt-40/tokens-with-dups.xml")
  stylesheet = layout.projectDirectory.file("style/elim-dup-tokens.xsl")
  result = layout.buildDirectory.file("xslt-40/tokens.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("xslt_grammar") {
  dependsOn("_strip_xslt_grammar", "_elimdup_xslt_grammar")
  source = layout.projectDirectory.file("specifications/xslt-40/src/xslt.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/convert-grammar.xsl")
  result = layout.buildDirectory.file("xslt-40/src/xslt-40-assembled.xml")
  parameters = mapOf(
      "spec" to "xslt40",
      "grammar-file"
        to "${layout.buildDirectory.file("xslt-40/temp-xslt40-grammar.xml").get().asFile.toURI()}",
      "tokens-file"
        to "${layout.buildDirectory.file("xslt-40/tokens.xml").get().asFile.toURI()}")
  dtdValidate = false
}

tasks.register<Copy>("_setup_xslt_merge_catalog") {
  into(layout.buildDirectory.dir("xslt-40/src"))
  from(layout.projectDirectory.dir("specifications/xslt-40/src")) {
    include("*.xsd")
    include("*.rnc")
    include("*.xsl")
  }
}

tasks.register<XsltTransform>("_xslt_streamability_expanded") {
  dependsOn("xslt_grammar", "saxon_config")
  source = layout.projectDirectory.file("specifications/xslt-40/src/function-catalog.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/function-streamability.xsl")
  result = layout.buildDirectory.file("xslt-40/built-in-streamability-expanded.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_merge_xslt_expanded0") {
  dependsOn("xslt_grammar", "saxon_config", "_xslt_streamability_expanded")
  source = layout.buildDirectory.file("xslt-40/src/xslt-40-assembled.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/merge-xslt-function-specs.xsl")
  result = layout.buildDirectory.file("xslt-40/src/xslt-expanded0.xml")
  parameters = mapOf(
    "function-catalog"
      to "${layout.projectDirectory.file("specifications/xslt-40/src/function-catalog.xml").asFile.toURI()}",
    "built-in-streamability-expanded"
      to "${layout.buildDirectory.file("xslt-40/built-in-streamability-expanded.xml").get().asFile.toURI()}")
  dtdValidate = false
}

tasks.register<XsltTransform>("_merge_xslt_expanded1") {
  dependsOn("_merge_xslt_expanded0")
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded0.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/merge-element-specs.xsl")
  result = layout.buildDirectory.file("xslt-40/src/xslt-expanded1.xml")
  parameters = mapOf(
    "catalog"
      to "${layout.projectDirectory.file("specifications/xslt-40/src/element-catalog.xml").asFile.toURI()}")
  dtdValidate = false
}

tasks.register<XsltTransform>("_merge_xslt_expanded2") {
  dependsOn("_merge_xslt_expanded1")
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded1.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/check-internal-links.xsl")
  result = layout.buildDirectory.file("xslt-40/src/xslt-expanded2.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("xslt_merge_catalog") {
  dependsOn("_merge_xslt_expanded1", "_merge_xslt_expanded2")
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded1.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/table-cleanup.xsl")
  result = layout.buildDirectory.file("xslt-40/src/xslt-expanded.xml")
  dtdValidate = false
}

tasks.register<Copy>("_xslt_resources_src") {
  into(layout.buildDirectory.dir("www/xslt-40"))
  from(layout.projectDirectory.dir("specifications/xslt-40/src")) {
    include("*.rnc")
    include("*.xsd")
    include("*.xsl")
  }
}

tasks.register<Copy>("_xslt_resources_css") {
  into(layout.buildDirectory.dir("www/xslt-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xslt-40.css")
  }
}

tasks.register<Copy>("_xslt_resources_js") {
  into(layout.buildDirectory.dir("www/xslt-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("xsl-datalist.js")
    include("toc.js")
  }
}

tasks.register<Redirect>("xslt_resources") {
  dependsOn("_xslt_resources_src", "_xslt_resources_css", "_xslt_resources_js")
  description = "Copy static resources for publication"
  index = layout.buildDirectory.file("www/xslt-40/index.html")
}

tasks.register<XsltTransform>("xslt_xml") {
  dependsOn("xslt_merge_catalog", "saxon_config")
  description = "Create the XML version of the specification"
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded.xml")
  stylesheet = layout.projectDirectory.file("style/identity.xsl")
  result = layout.buildDirectory.file("www/xslt-40/xslt-40.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_xslt_html") {
  dependsOn("xslt_merge_catalog", "xslt_resources",
            "setup_crossref_indexes", "saxon_config", "xslt_xml")
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-40/style/xslt.xsl")
  result = layout.buildDirectory.file("xslt-40/rendered.xml")
  parameters = mapOf(
      "baseline" to "",
      "use-local-css" to "0",
      "back.to.top.link" to "1")
  dtdValidate = false
}

tasks.register<HtmlFixup>("xslt_html") {
  dependsOn("_xslt_html")
  description = "Create the HTML version of the specification"
  source = layout.buildDirectory.file("xslt-40/rendered.xml")
  result = layout.buildDirectory.file("www/xslt-40/Overview.html")
}

// ============================================================

tasks.register("xpath_40") {
  group = "Specifications"
  description = "Build the XPath 4.0 specification"
  dependsOn ("xquery_xpath_html", "xquery_resources")
}

tasks.register("xquery_40") {
  group = "Specifications"
  description = "Build the XQuery 4.0 specification"
  dependsOn ("xquery_xquery_html", "xquery_resources")
}

for (shortName in listOf("xpath", "xquery")) {
  val thisSpec = shortName
  val notSpec = if (thisSpec == "xpath") "xquery" else "xpath"

  tasks.register<XsltTransform>("_strip_xquery_${shortName}_grammar") {
    dependsOn("grammar_40", "saxon_config")
    inputs.dir(layout.projectDirectory.dir("style"))
    inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/src"))
    inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/style"))
    inputs.dir(layout.projectDirectory.dir("specifications/grammar-40"))

    source = layout.buildDirectory.file("grammar-40/xpath-grammar.xml")
    stylesheet = layout.projectDirectory.file("specifications/grammar-40/parser/strip.xsl")
    result = layout.buildDirectory.file("xquery-40/temp-${shortName}-grammar.xml")
    parameters = mapOf(
        "spec1" to "${thisSpec}40",
        "spec2" to "dummy40")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("_tokens_xquery_${shortName}_grammar") {
    dependsOn("_strip_xquery_${shortName}_grammar")
    source = layout.buildDirectory.file("xquery-40/temp-${shortName}-grammar.xml")
    stylesheet = layout.projectDirectory.file("style/extract-tokens.xsl")
    result = layout.buildDirectory.file("xquery-40/${shortName}_tokens-with-dups.xml")
    parameters = mapOf(
        "spec" to shortName,
        "grammar-file"
          to "${layout.buildDirectory.file("xquery-40/temp-${shortName}-grammar.xml").get().asFile.toURI()}")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("xquery_${shortName}_grammar") {
    dependsOn("_tokens_xquery_${shortName}_grammar")
    description = "Build the grammar files for the ${shortName} specification"
    source = layout.buildDirectory.file("xquery-40/${shortName}_tokens-with-dups.xml")
    stylesheet = layout.projectDirectory.file("style/elim-dup-tokens.xsl")
    result = layout.buildDirectory.file("xquery-40/tokens-${shortName}.xml")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("_xquery_assemble_${shortName}") {
    dependsOn("xquery_${shortName}_grammar")
    inputs.dir(layout.projectDirectory.dir("style"))
    inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/src"))
    inputs.dir(layout.projectDirectory.dir("specifications/xquery-40/style"))
    inputs.dir(layout.projectDirectory.dir("specifications/grammar-40"))
    description = "Preprocess to pull together source files for (only) this spec"
    source = layout.projectDirectory.file("specifications/xquery-40/src/${shortName}.xml")
    stylesheet = layout.projectDirectory.file("specifications/xquery-40/style/preprocess-xquery.xsl")
    result = layout.buildDirectory.file("xquery-40/src/${shortName}-preprocessed.xml")
    parameters = mapOf("not-spec" to notSpec)
    dtdValidate = false
  }

  tasks.register<XsltTransform>("xquery_assemble_${shortName}") {
    dependsOn("_xquery_assemble_${shortName}")
    description = "Assemble the sources for the ${shortName} specification"

    // The assembly step is used to bring together all of the source
    // files that are incorporated by using entity references, but also
    // to transform grammar-related productions into XML elements that
    // can be readily rendered into a form needed in the HTML document.

    source = layout.buildDirectory.file("xquery-40/src/${shortName}-preprocessed.xml")
    stylesheet = layout.projectDirectory.file("specifications/xquery-40/style/assemble-xquery.xsl")
    result = layout.buildDirectory.file("xquery-40/src/${shortName}-assembled.xml")
    parameters = mapOf(
        "grammar-file"
          to "${layout.buildDirectory.file("xquery-40/temp-${shortName}-grammar.xml").get().asFile.toURI()}",
        "tokens-file"
          to "${layout.buildDirectory.file("xquery-40/tokens-${shortName}.xml").get().asFile.toURI()}",
        "spec" to "${shortName}40")
  }

  tasks.register<Copy>("_copy_xquery_${shortName}_html") {
    from(layout.projectDirectory.dir("specifications/xquery-40/images"))
    into(layout.buildDirectory.dir("xquery-40/images")) {
      include("*.svg")
    }
  }

  tasks.register<XsltTransform>("_xquery_${shortName}_html_xml") {
    dependsOn("xquery_assemble_${shortName}", "xquery_resources", "setup_crossref_indexes")
    source = layout.buildDirectory.file("xquery-40/src/${shortName}-assembled.xml")
    stylesheet = layout.projectDirectory.file("style/xsl-query-2016.xsl")
    result = layout.buildDirectory.file("xquery-40/${shortName}-html.xml")
    parameters = mapOf(
        "spec" to shortName,
        "additional.css" to "${shortName}-40.css",
        "kwFull" to "brief",
        "kwSort" to "cluster")
    dtdValidate = false
  }

  tasks.register<XsltTransform>("_xquery_${shortName}_xml") {
    dependsOn("_xquery_${shortName}_html_xml")
    source = layout.buildDirectory.file("xquery-40/${shortName}-html.xml")
    stylesheet = layout.projectDirectory.file("style/html-fix.xsl")
    result = layout.buildDirectory.file("xquery-40/${shortName}-40.xml")
    dtdValidate = false
  }

  tasks.register<HtmlFixup>("_xquery_${shortName}_html") {
    dependsOn("_xquery_${shortName}_xml")
    source = layout.buildDirectory.file("xquery-40/${shortName}-40.xml")
    result = layout.buildDirectory.file("xquery-40/${shortName}-40.html")
  }

  tasks.register<Copy>("xquery_${shortName}_html") {
    dependsOn("_xquery_${shortName}_html")
    description = "Create the HTML and XHTML versions of the ${shortName} specification"
    into(layout.buildDirectory.dir("www/xquery-40"))
    from(layout.buildDirectory.dir("xquery-40/src")) {
      include("${shortName}-assembled.xml")
      rename { "${shortName}-40.xml" }
    }
    from(layout.buildDirectory.dir("xquery-40")) {
      include("${shortName}-40.html")
    }
    from(layout.buildDirectory.dir("xquery-40/images"))
  }
}

tasks.register<Copy>("_xquery_resources_img") {
  into(layout.buildDirectory.dir("xquery-40/images"))
  from(layout.projectDirectory.dir("specifications/xquery-40/images"))
}

tasks.register<Copy>("_xquery_resources_css") {
  into(layout.buildDirectory.dir("www/xquery-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xpath-40.css")
    include("xquery-40.css")
  }
}

tasks.register<Copy>("_xquery_resources_js") {
  into(layout.buildDirectory.dir("www/xquery-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("toc.js")
  }
}

tasks.register("xquery_resources") {
  dependsOn("_xquery_resources_img", "_xquery_resources_css", "_xquery_resources_js")
  description = "Copy static resources for publication"

  doLast {
    // The index page for the xquery-40 directory lets you choose a spec
    val index = PrintStream(layout.buildDirectory.file("www/xquery-40/index.html").get().asFile)
    index.println("<!DOCTYPE html>")
    index.println("<html xmlns='http://www.w3.org/1999/xhtml'>")
    index.println("<head>");
    index.println("<title>Choose a specification</title>");
    index.println("</head>");
    index.println("<body>");
    index.println("<p>Choose <a href='xpath-40.html'>XPath</a>");
    index.println("or <a href='xquery-40.html'>XQuery</a></p>");
    index.println("</body>");
    index.println("</html>");
    index.close();
  }
}

// ============================================================

tasks.register("datamodel_40") {
  group = "Specifications"
  description = "Build the XPath Data Model 4.0 specification"
  dependsOn("datamodel_xml", "datamodel_html", "datamodel_resources")
}

tasks.register<Copy>("_datamodel_merge_setup") {
  into(layout.buildDirectory.dir("expanded/xpath-datamodel-40/"))

//  from(layout.projectDirectory.dir("specifications/xpath-datamodel-40/src"))

  from(layout.projectDirectory.dir("specifications/xpath-datamodel-40/src")) {
    include("dm-example.xml")
    include("dm-example.xsd")
    filter { line ->
      line.replace("&", "&amp;").replace("<", "&lt;")
    }
    rename { filename ->
      filename + ".cdata"
    }
  }
}

tasks.register<XsltTransform>("_datamodel_dm_example") {
  dependsOn("common_sources", "saxon_config", "_datamodel_merge_setup")
  source = layout.projectDirectory.file("specifications/xpath-datamodel-40/src/dm-example.xml")
  stylesheet = layout.projectDirectory.file("specifications/xpath-datamodel-40/style/dm-example.dm.xsl")
  result = layout.buildDirectory.file("expanded/xpath-datamodel-40/dm-example.dm.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_datamodel_tbl_example") {
  dependsOn("common_sources", "saxon_config", "_datamodel_dm_example")
  source = layout.buildDirectory.file("expanded/xpath-datamodel-40/dm-example.dm.xml")
  stylesheet = layout.projectDirectory.file("specifications/xpath-datamodel-40/style/dm-example.tbl.xsl")
  result = layout.buildDirectory.file("expanded/xpath-datamodel-40/dm-example.tbl.xml")
  dtdValidate = false
}

// The datamodel spec doesn't really need to be "merged" like many of the others
tasks.register<Copy>("datamodel_merge") {
  dependsOn("common_sources", "saxon_config", "_datamodel_merge_setup",
            "_datamodel_dm_example", "_datamodel_tbl_example")
  into(layout.buildDirectory.dir("expanded/xpath-datamodel-40"))
  from(layout.projectDirectory.file("specifications/xpath-datamodel-40/src"))
}

tasks.register<DtdValidate>("datamodel_validate") {
  dependsOn("datamodel_merge")
  source = layout.buildDirectory.file("expanded/xpath-datamodel-40/xpath-datamodel.xml")
  result = layout.buildDirectory.file("tmp/valid/xpath-datamodel.marker")
}

tasks.register<XsltTransform>("datamodel_xml") {
  dependsOn("datamodel_merge", "datamodel_validate", "saxon_config")
  group = "Spec XML"
  description = "Create the XML version of the specification"
  source = layout.buildDirectory.file("expanded/xpath-datamodel-40/xpath-datamodel.xml")
  stylesheet = layout.projectDirectory.file("style/identity.xsl")
  result = layout.buildDirectory.file("www/xpath-datamodel-40/xpath-datamodel-40.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_datamodel_html") {
  dependsOn("datamodel_merge", "setup_crossref_indexes", "saxon_config")
  source = layout.buildDirectory.file("expanded/xpath-datamodel-40/xpath-datamodel.xml")
  stylesheet = layout.projectDirectory.file("specifications/xpath-datamodel-40/style/data-model.xsl")
  result = layout.buildDirectory.file("www/xpath-datamodel-40/Overview.xml")
  dtdValidate = false
}

tasks.register<HtmlFixup>("datamodel_html") {
  dependsOn("_datamodel_html", "datamodel_resources")
  group = "Spec HTML"
  description = "Create the HTML and XHTML versions of the specification"
  source = layout.buildDirectory.file("www/xpath-datamodel-40/Overview.xml")
  result = layout.buildDirectory.file("www/xpath-datamodel-40/Overview.html")
}

tasks.register<Copy>("_datamodel_resources_src") {
  into(layout.buildDirectory.dir("www/xpath-datamodel-40"))
  from(layout.projectDirectory.dir("specifications/xpath-datamodel-40/src")) {
    include("dm-example.xml")
    include("dm-example.xsd")
    include("xpath-datatypes.xsd")
  }
}

tasks.register<Copy>("_datamodel_resources_images") {
  into(layout.buildDirectory.dir("www/xpath-datamodel-40/images"))
  from(layout.projectDirectory.dir("specifications/xpath-datamodel-40/images"))
}

tasks.register<Copy>("_datamodel_resources_css") {
  into(layout.buildDirectory.dir("www/xpath-datamodel-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xpath-datamodel-40.css")
  }
}

tasks.register<Copy>("_datamodel_resources_js") {
  into(layout.buildDirectory.dir("www/xpath-datamodel-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("toc.js")
  }
}

tasks.register<Redirect>("datamodel_resources") {
  dependsOn("_datamodel_resources_src", "_datamodel_resources_images",
            "_datamodel_resources_css", "_datamodel_resources_js")
  description = "Copy static resources for publication"
  index = layout.buildDirectory.file("www/xpath-datamodel-40/index.html")
}

// ============================================================

tasks.register("serialization_40") {
  dependsOn("serialization_xml", "serialization_html", "serialization_resources")
  group = "Specifications"
  description = "Build the XSLT/XQuery Serialization 4.0 specification"
}

tasks.register<DtdValidate>("_validate_serialization_xml") {
  source = layout.projectDirectory.file(
      "specifications/xslt-xquery-serialization-40/src/xslt-xquery-serialization.xml")
  result = layout.buildDirectory.file("tmp/valid/serialization.marker")
}

tasks.register<XsltTransform>("serialization_xml") {
  dependsOn("saxon_config", "_validate_serialization_xml")
  group = "Spec XML"
  description = "Create the XML version of the specification"
  source = layout.projectDirectory.file(
      "specifications/xslt-xquery-serialization-40/src/xslt-xquery-serialization.xml")
  stylesheet = layout.projectDirectory.file("style/identity.xsl")
  result = layout.buildDirectory.file("www/xslt-xquery-serialization-40/xslt-xquery-serialization-40.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_serialization_html") {
  dependsOn("serialization_xml", "setup_crossref_indexes", "saxon_config")
  source = layout.projectDirectory.file(
      "specifications/xslt-xquery-serialization-40/src/xslt-xquery-serialization.xml")
  stylesheet = layout.projectDirectory.file(
      "specifications/xslt-xquery-serialization-40/style/serialization.xsl")
  result = layout.buildDirectory.file("www/xslt-xquery-serialization-40/Overview.xml")
  dtdValidate = false
}

tasks.register<HtmlFixup>("serialization_html") {
  dependsOn("_serialization_html", "serialization_resources")
  group = "Spec HTML"
  description = "Create the HTML and XHTML versions of the specification"
  source = layout.buildDirectory.file("www/xslt-xquery-serialization-40/Overview.xml")
  result = layout.buildDirectory.file("www/xslt-xquery-serialization-40/Overview.html")
}

tasks.register<Copy>("_serialization_resources_src") {
  into(layout.buildDirectory.dir("www/xslt-xquery-serialization-40"))
  from(layout.projectDirectory.dir("specifications/xslt-xquery-serialization-40/src")) {
    include("schema-for-serialization-parameters.xsd")
  }
}

tasks.register<Copy>("_serialization_resources_css") {
  into(layout.buildDirectory.dir("www/xslt-xquery-serialization-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xslt-xquery-serialization-40.css")
  }
}

tasks.register<Copy>("_serialization_resources_js") {
  into(layout.buildDirectory.dir("www/xslt-xquery-serialization-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("toc.js")
  }
}

tasks.register<Redirect>("serialization_resources") {
  dependsOn("_serialization_resources_src",
            "_serialization_resources_css", "_serialization_resources_js")
  description = "Copy static resources for publication"
  index = layout.buildDirectory.file("www/xslt-xquery-serialization-40/index.html")
}

// ============================================================

tasks.register("xslt_streaming_40") {
  group = "Specifications"
  description = "Build the XSLT Streaming 4.0 specification"
  dependsOn("streaming_xml", "streaming_html", "streaming_resources")
}

tasks.register<DtdValidate>("_validate_streaming_xml") {
  source = layout.projectDirectory.file("specifications/xslt-streaming-40/src/xslt-streaming.xml")
  result = layout.buildDirectory.file("tmp/valid/xslt-streaming.marker")
}

tasks.register<XsltTransform>("streaming_xml") {
  group =  "Spec XML"
  description = "Create the XML version of the specification"
  dependsOn("saxon_config", "_validate_streaming_xml")
  source = layout.projectDirectory.file("specifications/xslt-streaming-40/src/xslt-streaming.xml")
  stylesheet = layout.projectDirectory.file("style/identity.xsl")
  result = layout.buildDirectory.file("www/xslt-streaming-40/xslt-streaming-40.xml")
  dtdValidate = false
}

tasks.register<XsltTransform>("_streaming_html") {
  group = "Spec HTML"
  dependsOn("streaming_xml", "setup_crossref_indexes", "saxon_config")
  source = layout.projectDirectory.file("specifications/xslt-streaming-40/src/xslt-streaming.xml")
  stylesheet = layout.projectDirectory.file("specifications/xslt-streaming-40/style/streaming.xsl")
  result = layout.buildDirectory.file("www/xslt-streaming-40/Overview.xml")
  dtdValidate = false
}

tasks.register<HtmlFixup>("streaming_html") {
  dependsOn("_streaming_html")
  description = "Create the HTML and XHTML versions of the specification"
  source = layout.buildDirectory.file("www/xslt-streaming-40/Overview.xml")
  result = layout.buildDirectory.file("www/xslt-streaming-40/Overview.html")
}

tasks.register<Copy>("_streaming_resources_css") {
  into(layout.buildDirectory.dir("www/xslt-streaming-40/css"))
  from(layout.projectDirectory.dir("specifications/css")) {
    include("w3c-base.css")
    include("qtspecs.css")
    include("xslt-streaming-40.css")
  }
}

tasks.register<Copy>("_streaming_resources_js") {
  into(layout.buildDirectory.dir("www/xslt-streaming-40/js"))
  from(layout.projectDirectory.dir("specifications/js")) {
    include("toc.js")
  }
}

tasks.register<Redirect>("streaming_resources") {
  dependsOn("_streaming_resources_css", "_streaming_resources_js")
  description = "Copy static resources for publication"
  index = layout.buildDirectory.file("www/xslt-streaming-40/index.html")
}

// ============================================================

tasks.register<XsltTransform>("setup_crossref_indexes") {
  dependsOn("etc_copy", "etc_DM40", "etc_FO40", "etc_XT40", "etc_SG40", "etc_SE40",
            "etc_XP40", "etc_XQ40",
            "etc_BIN40", "etc_FILE40")
  stylesheet = layout.projectDirectory.file("style/build-database.xsl")
  result = layout.buildDirectory.file("etc/database.xml")
  options = listOf("-it")
  dtdValidate = false
}

tasks.register<Copy>("etc_copy") {
  into(layout.buildDirectory.dir("etc"))
  from(layout.projectDirectory.dir("etc"))
}

tasks.register<XsltTransform>("etc_DM40") {
  dependsOn("datamodel_merge", "saxon_config")
  description = "Build the etc/DM40.xml index"

  source = layout.buildDirectory.file("expanded/xpath-datamodel-40/xpath-datamodel.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/DM40.xml")
  parameters = mapOf(
      "specdoc" to "DM",
      "uri" to "https://qt4cg.org/specifications/xpath-datamodel-40/")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_FO40") {
  dependsOn("fo_merge", "saxon_config")
  description = "Build the etc/DM40.xml index"

  source = layout.buildDirectory.file("expanded/xpath-functions-40/xpath-functions-40.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/FO40.xml")
  parameters = mapOf(
      "specdoc" to "FO",
      "uri" to "https://qt4cg.org/specifications/xpath-functions-40/")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_XP40") {
  dependsOn("xquery_assemble_xpath", "saxon_config")
  description = "Build the etc/XP40.xml index"
  source = layout.buildDirectory.file("xquery-40/src/xpath-assembled.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/XP40.xml")
  parameters = mapOf(
      "specdoc" to "XP",
      "uri" to "https://qt4cg.org/specifications/xquery-40/xpath-40.html")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_XQ40") {
  dependsOn("xquery_assemble_xquery", "saxon_config")
  description = "Build the etc/XQ40.xml index"
  source = layout.buildDirectory.file("xquery-40/src/xquery-assembled.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/XQ40.xml")
  parameters = mapOf(
      "specdoc" to "XQ",
      "uri" to "https://qt4cg.org/specifications/xquery-40/xquery-40.html")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_XT40") {
  dependsOn("xslt_merge_catalog", "saxon_config")
  description = "Build the etc/XT40.xml index"
  source = layout.buildDirectory.file("xslt-40/src/xslt-expanded.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/XT40.xml")
  parameters = mapOf(
      "specdoc" to "XQXP", // FIXME: really? "XQXP"?
      "uri" to "https://qt4cg.org/specifications/xslt-40/")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_SG40") {
  dependsOn("saxon_config")
  description = "Build the etc/SG40.xml index"
  source = layout.projectDirectory.file("specifications/xslt-streaming-40/src/xslt-streaming.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/SG40.xml")
  parameters = mapOf(
      "specdoc" to "STRM",
      "uri" to "https://qt4cg.org/specifications/xslt-streaming-40/")
  dtdValidate = false
}

tasks.register<XsltTransform>("etc_SE40") {
  dependsOn("saxon_config")
  description = "Build the etc/SE40.xml index"
  source = layout.projectDirectory.file(
      "specifications/xslt-xquery-serialization-40/src/xslt-xquery-serialization.xml")
  stylesheet = layout.projectDirectory.file("style/extract.xsl")
  result = layout.buildDirectory.file("etc/SE40.xml")
  parameters = mapOf(
      "specdoc" to "SE",
      "uri" to "https://qt4cg.org/specifications/xslt-xquery-serialization-40/")
  dtdValidate = false
}

tasks.register<Copy>("grammarExplorer") {
  dependsOn("oldGrammars", "currentGrammars")
  into(layout.buildDirectory.dir("www/grammar-explorer"))
  from(layout.projectDirectory.dir("explorer")) {
    include("index.html")
    include("grammar.css")
  }
}

val oldGrammars = tasks.register("oldGrammars") {
  // a place to hang dependencies
}

for (grammar in listOf("xpath30", "xpath31", "xquery10", "xquery30", "xquery31", "xslt30-patterns")) {
  tasks.register<XsltTransform>("grammar_explorer_${grammar}") {
    dependsOn("publish")
    description = "Build the grammar explorer for ${grammar}"
    source = layout.projectDirectory.file("explorer/old-versions/config.xml")
    stylesheet = layout.projectDirectory.file("explorer/grammar-explorer.xsl")
    result = layout.buildDirectory.file("www/grammar-explorer/${grammar}/index.html")
    parameters = mapOf("grammar" to grammar)
    dtdValidate = false
  }

  val t = tasks.register<Copy>("copy_${grammar}_css") {
    dependsOn("grammar_explorer_${grammar}")
    into(layout.buildDirectory.dir("www/grammar-explorer/${grammar}"))
    from(layout.projectDirectory.dir("explorer")) {
      include("grammar.css")
    }
  }

  oldGrammars { dependsOn(t) }
}

val currentGrammars = tasks.register("currentGrammars") {
  // a place to hang dependencies
}

for (grammar in listOf("xpath40", "xquery40", "xslt40-patterns")) {
  tasks.register<XsltTransform>("grammar_explorer_${grammar}") {
    dependsOn("publish")
    description = "Build the grammar explorer for ${grammar}"
    source = layout.projectDirectory.file("explorer/config.xml")
    stylesheet = layout.projectDirectory.file("explorer/grammar-explorer.xsl")
    result = layout.buildDirectory.file("www/grammar-explorer/${grammar}/index.html")
    parameters = mapOf("grammar" to grammar)
    dtdValidate = false
  }

  val t = tasks.register<Copy>("copy_${grammar}_css") {
    dependsOn("grammar_explorer_${grammar}")
    into(layout.buildDirectory.dir("www/grammar-explorer/${grammar}"))
    from(layout.projectDirectory.dir("explorer")) {
      include("grammar.css")
    }
  }

  currentGrammars { dependsOn(t) }
}

// You need a Saxon license key with the DMK feature to usefully run this task.
tasks.register<XsdValidate>("updateSEF") {
  dependsOn("saxon_config")
  schema = layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.xsd")
  result = layout.buildDirectory.file("tmp/valid/sef.marker")
  options = listOf(
      "-config:${layout.buildDirectory.file("config.xml").get().asFile}",
      "-export:${layout.projectDirectory.file("specifications/xpath-functions-40/src/fos.scm")}")
}
