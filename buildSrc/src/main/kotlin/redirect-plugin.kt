package org.qt4cg.gradle

import org.gradle.api.DefaultTask
import org.gradle.api.GradleException
import org.gradle.api.Plugin
import org.gradle.api.Project
import org.gradle.api.file.ConfigurableFileCollection
import org.gradle.api.file.RegularFileProperty
import org.gradle.api.provider.ListProperty
import org.gradle.api.provider.MapProperty
import org.gradle.api.provider.Property
import org.gradle.api.tasks.*
import org.gradle.kotlin.dsl.create
import org.gradle.process.ExecOperations
import javax.inject.Inject
import java.io.PrintStream

interface RedirectExtension {
  abstract val project: Property<Project>
  abstract val debug: Property<Boolean>
}

class RedirectPlugin : Plugin<Project> {
  override fun apply(project: Project) {
    val extension = project.extensions.create<RedirectExtension>("redirect")
    extension.project.set(project)
    extension.debug.convention(false)
  }
}

abstract class Redirect @Inject constructor(private val ex: ExecOperations): DefaultTask() {
  @get:OutputFile
  @get:Optional
  abstract val index: RegularFileProperty

  @get:Internal
  val redirectExt = project.extensions.findByType(RedirectExtension::class.java)

  @TaskAction
  fun transform() {
    if (redirectExt is RedirectExtension) {
      redirectExt as RedirectExtension
    } else {
      throw GradleException("Could not find redirect extension")
    }

    // The W3C uses index files called Overview.html, so that's what the
    // build produces. But everyone else, including the GitHub pages that
    // back qt4cg.org, uses index.html. So redirect.
    val stream = PrintStream(index.get().asFile)
    stream.println("<!DOCTYPE html>")
    stream.println("<html xmlns='http://www.w3.org/1999/xhtml'>")
    stream.println("<head>");
    stream.println("<meta http-equiv='refresh' content='0; url=Overview.html' />");
    stream.println("</head>");
    stream.println("<body>");
    stream.println("<p>See <a href='Overview.html'>Overview</a>.</p>");
    stream.println("</body>");
    stream.println("</html>");
    stream.close();
  }
}
