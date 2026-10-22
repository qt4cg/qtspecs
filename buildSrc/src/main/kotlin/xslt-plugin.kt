package org.qt4cg.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.artifacts.Configuration
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.file.RegularFileProperty
import org.gradle.api.provider.ListProperty
import org.gradle.api.provider.MapProperty
import org.gradle.api.provider.Property
import org.gradle.api.tasks.*
import org.gradle.kotlin.dsl.create
import org.gradle.process.ExecOperations
import javax.inject.Inject

interface XsltExtension {
  abstract val project: Property<Project>
  abstract val jvmArgs: ListProperty<String>
  abstract val configuration: Property<Configuration>
  abstract val debug: Property<Boolean>
  abstract val dtdValidate: Property<Boolean>
  abstract val defaultParameters: MapProperty<String,String>
}

class XsltPlugin : Plugin<Project> {
  override fun apply(project: Project) {
    val extension = project.extensions.create<XsltExtension>("xslt")
    extension.project.set(project)
    extension.debug.convention(false)
    extension.dtdValidate.convention(true)
    extension.defaultParameters.convention(emptyMap())
    extension.jvmArgs.convention(
        listOf("-Xmx4096m", "-Djdk.xml.totalEntitySizeLimit=0", "-Djdk.xml.maxGeneralEntitySizeLimit=0",
               "-Djdk.xml.maxParameterEntitySizeLimit=0"))
  }
}

abstract class XsltTransform @Inject constructor(private val ex: ExecOperations): DefaultTask() {
  @get:InputFiles
  @get:Optional
  abstract val classpath: ConfigurableFileCollection

  @get:InputFile
  @get:Optional
  abstract val source: RegularFileProperty

  @get:InputFile
  abstract val stylesheet: RegularFileProperty

  @get:Input
  abstract val parameters: MapProperty<String,String>

  @get:Input
  abstract val options: ListProperty<String>

  @get:OutputFile
  @get:Optional
  abstract val result: RegularFileProperty

  @get:Input
  @get:Optional
  abstract val dtdValidate: Property<Boolean>

  @get:Internal
  val xsltExt = project.extensions.findByType(XsltExtension::class.java)

  @TaskAction
  fun transform() {
    if (xsltExt is XsltExtension) {
      xsltExt as XsltExtension
    } else {
      throw GradleException("Could not find XSLT extension")
    }

    val javaClass = "net.sf.saxon.Transform"

    val argList = mutableListOf<String>()

    for (opt in options.get()) {
      argList.add(opt)
    }

    if (source.getOrNull() != null) {
      argList.add("-s:${source.get()}")
    }

    argList.add("-xsl:${stylesheet.get()}")
    if (result.getOrNull() != null) {
      argList.add("-o:${result.get()}")
    }

    val combined = mutableMapOf<String,String>()
    combined.putAll(xsltExt.defaultParameters.get())
    combined.putAll(parameters.get())

    for ((pkey, pvalue) in combined) {
      argList.add("${pkey}=${pvalue}")
    }

    if (xsltExt.debug.get()) {
      println("${javaClass} ${argList.joinToString(" ")}")
    }

    val cp = if (classpath.getFrom().isEmpty()) {
      xsltExt.configuration.getOrNull()
          ?: throw GradleException("XSLT plugin is unconfigured")
    } else {
      classpath
    }

    ex.javaexec {
      if (xsltExt.jvmArgs.get().isNotEmpty()) {
        jvmArgs(xsltExt.jvmArgs.get())
      }
      classpath = cp
      mainClass.set(javaClass)
      args(argList)
    }

    val validate = dtdValidate.getOrNull() ?: xsltExt.dtdValidate.get()
    if (validate && result.getOrNull() != null) {
      ex.javaexec {
        classpath = cp
        mainClass.set("com.nwalsh.parsers.XJParse")
        args(listOf("-v", "${result.get()}"))
      }
    }
  }
}
