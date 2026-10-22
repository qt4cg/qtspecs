// Read the configuration properties from the "main" project so that I don't have to
// maintain them in two places.
layout.projectDirectory.file("../gradle.properties").asFile.readLines().forEach { input ->
  val line = input.trim()
  if (!line.isBlank() && !line.startsWith("#") && !line.startsWith("//")) {
    val parts = line.split("=").map { it.trim() }
    val property = parts.first()
    val value = parts.last()

    // Ignore the build-related properties
    if (!property.startsWith("kotlin.") && !property.startsWith("org.gradle.")) {
      project.extra[property] = value
      //println("${property}=${value}")
    }
  }
}

val saxonVersion = project.findProperty("saxonVersion") as String

plugins {
    `kotlin-dsl`
}

repositories {
    gradlePluginPortal()
    mavenLocal()
    mavenCentral()
    maven { url = uri("https://maven.saxonica.com/maven") }
}

dependencies {
  implementation("org.jetbrains.kotlin:kotlin-gradle-plugin:2.3.21")
  implementation(libs.kotlin.gradle.plugin)
  implementation("nu.validator.htmlparser:htmlparser:1.4")
  implementation("com.saxonica:Saxon-EE:${saxonVersion}")
}

gradlePlugin {
  plugins {
    create("xslt-plugin") {
      id = "org.qt4cg.gradle.xslt"
      implementationClass = "org.qt4cg.gradle.XsltPlugin"
    }
    create("dtd-validate-plugin") {
      id = "org.qt4cg.gradle.dtd-validate"
      implementationClass = "org.qt4cg.gradle.DtdValidatePlugin"
    }
    create("xsd-validate-plugin") {
      id = "org.qt4cg.gradle.xsd-validate"
      implementationClass = "org.qt4cg.gradle.XsdValidatePlugin"
    }
    create("html-fixup-plugin") {
      id = "org.qt4cg.gradle.html-fixup"
      implementationClass = "org.qt4cg.gradle.HtmlFixupPlugin"
    }
    create("redirect-plugin") {
      id = "org.qt4cg.gradle.redirect"
      implementationClass = "org.qt4cg.gradle.RedirectPlugin"
    }
  }
}
