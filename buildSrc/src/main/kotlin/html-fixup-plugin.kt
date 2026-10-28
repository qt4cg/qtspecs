package org.qt4cg.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.artifacts.Configuration
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.provider.ListProperty
import org.gradle.api.file.RegularFileProperty
import org.gradle.api.file.DirectoryProperty
import org.gradle.api.provider.Property
import org.gradle.api.tasks.*
import org.gradle.api.tasks.Optional
import org.gradle.kotlin.dsl.create
import org.gradle.process.ExecOperations
import java.text.SimpleDateFormat
import java.util.*
import javax.inject.Inject

interface HtmlFixupExtension {
  abstract val project: Property<Project>
  abstract val jvmArgs: ListProperty<String>
  abstract val configuration: Property<Configuration>
  abstract val debug: Property<Boolean>
  abstract val timestamp: Property<String>
  abstract val buildDirectory: DirectoryProperty
}

class HtmlFixupPlugin : Plugin<Project> {
  override fun apply(project: Project) {
    val extension = project.extensions.create<HtmlFixupExtension>("html-fixup")
    extension.project.set(project)
    extension.buildDirectory.convention(project.layout.buildDirectory)
    extension.debug.convention(false)
    extension.timestamp.convention(SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(Date()).toString())
    extension.jvmArgs.convention(
        listOf("-Xmx4096m", "-Djdk.xml.totalEntitySizeLimit=0", "-Djdk.xml.maxGeneralEntitySizeLimit=0",
               "-Djdk.xml.maxParameterEntitySizeLimit=0"))
  }
}

abstract class HtmlFixup @Inject constructor(private val ex: ExecOperations): DefaultTask() {
  @get:InputFiles
  @get:Optional
  abstract val classpath: ConfigurableFileCollection

  @get:InputFile
  abstract val source: RegularFileProperty

  @get:OutputFile
  abstract val result: RegularFileProperty

  @get:Internal
  val fixupExt = project.extensions.findByType(HtmlFixupExtension::class.java)

  @TaskAction
  fun fixup() {
    if (fixupExt is HtmlFixupExtension) {
      fixupExt as HtmlFixupExtension
    } else {
      throw GradleException("Could not find HTML fixup extension")
    }

    val javaClass = "net.sf.saxon.Query"

    val argList = mutableListOf<String>()

    val configXml = fixupExt.buildDirectory.file("config.xml").get().asFile
    if (configXml.exists()) {
      argList.add("-config:${configXml}")
    }

    argList.add("-qs:.")
    argList.add("-s:${source.get()}")
    argList.add("-o:${result.get()}")
    //argList.add("-config:???")
    argList.add("currentDateTime=${fixupExt.timestamp.get()}")
    argList.add("!method=html")
    argList.add("!version=5")
    argList.add("!indent=yes")
    argList.add("!suppress-indentation={http://www.w3.org/1999/xhtml}p {http://www.w3.org/1999/xhtml}pre")

    if (fixupExt.debug.get()) {
      println("${javaClass} ${argList.joinToString(" ")}")
    }

    val cp = if (classpath.getFrom().isEmpty()) {
      fixupExt.configuration.getOrNull()
          ?: throw GradleException("HTML fixup plugin is unconfigured")
    } else {
      classpath
    }

    ex.javaexec {
      if (fixupExt.jvmArgs.get().isNotEmpty()) {
        jvmArgs(fixupExt.jvmArgs.get())
      }
      classpath = cp
      mainClass.set(javaClass)
      args(argList)
    }
  }
}
