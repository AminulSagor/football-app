plugins {
    id("com.android.library") apply false
}

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
    configurations.all {
        resolutionStrategy.eachDependency {
            if (requested.group == "com.facebook.android" &&
                requested.name == "audience-network-sdk"
            ) {
                useVersion("6.21.0")
            }
        }
    }
}


subprojects {
    if (name == "facebook_audience_network") {
        fun patchFacebookAudienceNetworkManifestPackage() {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (!manifestFile.exists()) return

            val currentManifest = manifestFile.readText()
            val patchedManifest = currentManifest.replace(
                Regex("\\s+package=\"[^\"]*\""),
                "",
            )

            if (currentManifest != patchedManifest) {
                manifestFile.writeText(patchedManifest)
            }
        }

        patchFacebookAudienceNetworkManifestPackage()

        tasks.matching { task ->
            task.name.startsWith("process") && task.name.endsWith("Manifest")
        }.configureEach {
            doFirst {
                patchFacebookAudienceNetworkManifestPackage()
            }
        }
    }
}

subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
            if (namespace == null) {
                namespace = when (project.name) {
                    "facebook_audience_network" -> "com.msunited.kicscore.facebook_audience_network"
                    else -> "com.msunited.kicscore.${project.name.replace('-', '_')}"
                }
            }
        }
    }
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
