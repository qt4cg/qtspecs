package org.qt4cg.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.artifacts.Configuration
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.file.RegularFileProperty
import org.gradle.api.provider.ListProperty
import org.gradle.api.provider.Property
import org.gradle.api.tasks.*
import org.gradle.api.tasks.Optional
import org.gradle.kotlin.dsl.create
import org.gradle.process.ExecOperations
import java.io.PrintStream
import java.util.*
import javax.inject.Inject

interface XsdValidateExtension {
  abstract val project: Property<Project>
  abstract val jvmArgs: ListProperty<String>
  abstract val configuration: Property<Configuration>
  abstract val debug: Property<Boolean>
}

class XsdValidatePlugin : Plugin<Project> {
  override fun apply(project: Project) {
    val extension = project.extensions.create<XsdValidateExtension>("xsd-validate")
    extension.project.set(project)
    extension.debug.convention(false)
    extension.jvmArgs.convention(
        listOf("-Xmx4096m", "-Djdk.xml.totalEntitySizeLimit=0", "-Djdk.xml.maxGeneralEntitySizeLimit=0",
               "-Djdk.xml.maxParameterEntitySizeLimit=0"))
  }
}

abstract class XsdValidate @Inject constructor(private val ex: ExecOperations): DefaultTask() {
  @get:InputFiles
  @get:Optional
  abstract val classpath: ConfigurableFileCollection

  @get:InputFile
  @get:Optional
  abstract val source: RegularFileProperty

  @get:InputFile
  @get:Optional
  abstract val schema: RegularFileProperty

  @get:Input
  abstract val options: ListProperty<String>

  @get:OutputFile
  @get:Optional
  abstract val result: RegularFileProperty

  @get:Internal
  val xsdExt = project.extensions.findByType(XsdValidateExtension::class.java)

  @TaskAction
  fun validate() {
    if (xsdExt is XsdValidateExtension) {
      xsdExt as XsdValidateExtension
    } else {
      throw GradleException("Could not find XSD extension")
    }

    val javaClass = "com.saxonica.Validate"

    val argList = mutableListOf<String>()

    for (opt in options.get()) {
      argList.add(opt)
    }

    if (source.getOrNull() != null) {
      argList.add("-s:${source.get()}")
    }

    if (schema.getOrNull() != null) {
      argList.add("-xsd:${schema.get()}")
    }

    if (xsdExt.debug.get()) {
      println("${javaClass} ${argList.joinToString(" ")}")
    }

    val cp = if (classpath.getFrom().isEmpty()) {
      xsdExt.configuration.getOrNull()
          ?: throw GradleException("XSD validation plugin is unconfigured")
    } else {
      classpath
    }

    ex.javaexec {
      if (xsdExt.jvmArgs.get().isNotEmpty()) {
        jvmArgs(xsdExt.jvmArgs.get())
      }
      classpath = cp
      mainClass.set(javaClass)
      args(argList)
    }

    if (result.getOrNull() != null) {
      val stream = PrintStream(result.get().asFile)
      stream.println(UUID.randomUUID())
      stream.close()
    }
  }
}
