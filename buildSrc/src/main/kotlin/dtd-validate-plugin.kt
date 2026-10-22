package org.qt4cg.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.artifacts.Configuration
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.provider.ListProperty
import org.gradle.api.file.RegularFileProperty
import org.gradle.api.provider.Property
import org.gradle.api.tasks.*
import org.gradle.api.tasks.Optional
import org.gradle.kotlin.dsl.create
import org.gradle.process.ExecOperations
import java.io.PrintStream
import java.util.*
import javax.inject.Inject

interface DtdValidateExtension {
  abstract val project: Property<Project>
  abstract val jvmArgs: ListProperty<String>
  abstract val configuration: Property<Configuration>
  abstract val debug: Property<Boolean>
}

class DtdValidatePlugin : Plugin<Project> {
  override fun apply(project: Project) {
    val extension = project.extensions.create<DtdValidateExtension>("dtd-validate")
    extension.project.set(project)
    extension.debug.convention(false)
    extension.jvmArgs.convention(
        listOf("-Xmx4096m", "-Djdk.xml.totalEntitySizeLimit=0", "-Djdk.xml.maxGeneralEntitySizeLimit=0",
               "-Djdk.xml.maxParameterEntitySizeLimit=0"))
  }
}

abstract class DtdValidate @Inject constructor(private val ex: ExecOperations): DefaultTask() {
  @get:InputFiles
  @get:Optional
  abstract val classpath: ConfigurableFileCollection

  @get:InputFile
  abstract val source: RegularFileProperty

  @get:OutputFile
  @get:Optional
  abstract val result: RegularFileProperty

  @get:Internal
  val dtdExt = project.extensions.findByType(DtdValidateExtension::class.java)

  @TaskAction
  fun validate() {
    if (dtdExt is DtdValidateExtension) {
      dtdExt as DtdValidateExtension
    } else {
      throw GradleException("Could not find DTD extension")
    }

    val javaClass = "com.nwalsh.parsers.XJParse"

    val argList = mutableListOf<String>()
    argList.add("-v")
    argList.add("${source.get()}")

    if (dtdExt.debug.get()) {
      println("${javaClass} ${argList.joinToString(" ")}")
    }      

    val cp = if (classpath.getFrom().isEmpty()) {
      dtdExt.configuration.getOrNull()
          ?: throw GradleException("DTD validation plugin is unconfigured")
    } else {
      classpath
    }

    ex.javaexec {
      if (dtdExt.jvmArgs.get().isNotEmpty()) {
        jvmArgs(dtdExt.jvmArgs.get())
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
