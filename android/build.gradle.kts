allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Workaround: set namespace on the google_mobile_ads subproject after all projects
// are evaluated. Use reflection to avoid adding AGP compile-time deps in this script.
gradle.projectsEvaluated {
    rootProject.subprojects.forEach { p ->
        try {
            if (p.name == "google_mobile_ads") {
                val androidExt = p.extensions.findByName("android")
                if (androidExt != null) {
                    val kClass = androidExt::class.java
                    val methods = kClass.methods
                    val setter = methods.firstOrNull { it.name == "setNamespace" || it.name == "namespace" }
                    if (setter != null) {
                        try {
                            setter.invoke(androidExt, "com.google.ads.flutter.google_mobile_ads")
                        } catch (_: Throwable) {
                            // ignore failures
                        }
                    }
                }
            }
        } catch (e: Throwable) {
            println("Warning: failed to apply namespace workaround for ${p.name}: ${e.message}")
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
