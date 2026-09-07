import java.util.Date
import java.io.FileOutputStream

plugins {
  id("java")
}

repositories {
  mavenLocal()
  mavenCentral()
  maven { url = uri("https://maven.saxonica.com/maven") }
}

val saxon = configurations.create("saxon") {
  extendsFrom(configurations["implementation"])
}

// Set saxonLicenseDir in gradle.properties, or from the
// command line if you have a license in some other place.
val saxonLicenseDir =
    project.findProperty("saxonLicenseDir") ?: "${System.getenv("HOME")}/java"

dependencies {
  implementation("com.saxonica:Saxon-EE:11.4")
  implementation("com.nwalsh:scommonmark:0.0.1")
  saxon(files(saxonLicenseDir))
}

// ============================================================

defaultTasks("showhelp")

tasks.register("showhelp") {
  doLast {
    println("The compileXslt task will recompile the dashboard.")
    println("The rss task will rebuild the RSS feed.");
    println("The dashboard task will rebuild the dashboard.");
  }
}

// ============================================================

// There are several places where I'd just rather have several exec{}
// operations in a single task than have several <Exec> tasks. This
// bit of ceremony allows that to work in Gradle 9.
interface InjectedExecOps {
    @get:Inject
    val execOps: ExecOperations
}

tasks.register<JavaExec>("rss") {
  dependsOn("updateIssues")
  inputs.files(fileTree("dir" to layout.projectDirectory.dir("src/status"),
                        "include" to "20*/*"))
  inputs.file(layout.projectDirectory.file("src/status/status-rss.xsl"))
  outputs.file(layout.projectDirectory.file("@qt4cg/status.rss"))
  
  classpath = configurations["saxon"]
  mainClass = "com.saxonica.Transform"
  args("-it", "-xsl:${layout.projectDirectory.file("src/status/status-rss.xsl")}")
}

tasks.register<JavaExec>("updateIssues") {
  dependsOn("updateLocalIssues")
  inputs.file(layout.projectDirectory.file("src/status/qtspecs-issues.json"))
  inputs.file(layout.projectDirectory.file("src/status/issues.xsl"))
  outputs.dir(layout.projectDirectory.file("src/status"))
  
  classpath = configurations["saxon"]
  mainClass = "com.saxonica.Transform"
  args("-it", "-xsl:${layout.projectDirectory.file("src/status/issues.xsl")}",
       "-init:com.nwalsh.commonmark.Register")
}

tasks.register<JavaExec>("updateAvailablePRs") {
  dependsOn("updateLocalIssues", "updateIssues")
  inputs.file(layout.projectDirectory.file("src/status/qtspecs-issues.json"))
  inputs.file(layout.projectDirectory.file("src/status/available-prs.xsl"))
  outputs.file(layout.projectDirectory.file("available-prs.html"))
  
  classpath = configurations["saxon"]
  mainClass = "com.saxonica.Transform"
  args("-it",
       "-xsl:${layout.projectDirectory.file("src/status/available-prs.xsl")}",
       "-o:${layout.projectDirectory.file("available-prs.html")}")
}

tasks.register("updateLocalIssues") {
  val injected = project.objects.newInstance<InjectedExecOps>()

  finalizedBy("updateAvailablePRs")

  val issues = layout.projectDirectory.file("src/status/qtspecs-issues.json").asFile
  var update = true
  if (issues.exists()) {
    val now = Date().getTime();
    val age_sec = (now - issues.lastModified()) / 1000
    update = age_sec > 3600
  }

  if (update) {
    doLast {
      injected.execOps.exec {
        workingDir(layout.projectDirectory.file("src/status"))
        commandLine("/bin/sh", "./get-qt4cg-issues.sh", "qtspecs-issues.json")
      }
    } 
  } else {
    doLast {
      println("Issues file is too recent, erase it to force update.")
    }
  }
}

// ============================================================

tasks.register<Exec>("prlist") {
  inputs.dir(layout.projectDirectory.file("pr"))
  outputs.file(layout.buildDirectory.file("pr-list.txt"))
  val recordBranch = FileOutputStream(layout.buildDirectory.file("pr-list.txt").get().asFile)
  standardOutput = recordBranch
  commandLine("find", "pr", "-type", "f", "-print")
}

tasks.register<JavaExec>("dashboard") {
  dependsOn("prlist")
  inputs.file(layout.projectDirectory.file("dashboard/static.xsl"))
  outputs.file(layout.projectDirectory.file("dashboard/index.html"))
  classpath = configurations["saxon"]
  mainClass = "com.saxonica.Transform"
  args("-it",
       "-xsl:${layout.projectDirectory.file("dashboard/static.xsl")}",
       "-o:${layout.projectDirectory.file("dashboard/index.html")}")
}

// ============================================================

if (project.file("${saxonLicenseDir}/saxon-license.lic").exists()) {
  // We can compile the stylesheet
  tasks.register<JavaExec>("compileXslt") {
    inputs.file(layout.projectDirectory.file("dashboard/dashboard.xsl"))
    outputs.file(layout.projectDirectory.file("dashboard/dashboard.sef.json"))
    classpath = configurations["saxon"]
    mainClass = "com.saxonica.Transform"
    args("-t",
         "-xsl:${layout.projectDirectory.file("dashboard/dashboard.xsl")}",
         "-export:${layout.projectDirectory.file("dashboard/dashboard.sef.json")}",
         "-target:JS", "-nogo", "-relocate:on", "-ns:##html5")
  }
} else {
  tasks.register("compileXslt") {
    doLast {
      throw GradleException("Failed to find Saxon license.")
    }
  }
}
