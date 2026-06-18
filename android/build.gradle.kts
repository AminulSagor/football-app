plugins {
    id("com.android.library") apply false
}

val kicscoreCompileSdk = 36
val facebookAudienceNetworkNamespace =
    "com.msunited.kicscore.facebook_audience_network"

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
        fun patchFacebookAudienceNetworkPluginFiles() {
            val manifestFile = file("src/main/AndroidManifest.xml")
            if (manifestFile.exists()) {
                val currentManifest = manifestFile.readText()
                val patchedManifest = currentManifest.replace(
                    Regex("\\s+package=[^\\s>]+"),
                    "",
                )

                if (currentManifest != patchedManifest) {
                    manifestFile.writeText(patchedManifest)
                }
            }

            listOf(file("build.gradle"), file("build.gradle.kts"))
                .filter { it.exists() }
                .forEach { buildFile ->
                    val currentBuildFile = buildFile.readText()
                    val patchedBuildFile = currentBuildFile
                        .replace(
                            Regex("compileSdkVersion\\s+[^\\r\\n]+"),
                            "compileSdkVersion $kicscoreCompileSdk",
                        )
                        .replace(
                            Regex("compileSdkVersion\\s*=\\s*[^\\r\\n]+"),
                            "compileSdkVersion = $kicscoreCompileSdk",
                        )
                        .replace(
                            Regex("compileSdk\\s+\\d+"),
                            "compileSdk $kicscoreCompileSdk",
                        )
                        .replace(
                            Regex("compileSdk\\s*=\\s*\\d+"),
                            "compileSdk = $kicscoreCompileSdk",
                        )

                    if (currentBuildFile != patchedBuildFile) {
                        buildFile.writeText(patchedBuildFile)
                    }
                }
        }

        patchFacebookAudienceNetworkPluginFiles()

        tasks.matching { task ->
            (task.name.startsWith("process") && task.name.endsWith("Manifest")) ||
                (task.name.startsWith("verify") && task.name.endsWith("Resources"))
        }.configureEach {
            doFirst {
                patchFacebookAudienceNetworkPluginFiles()
            }
        }
    }
}

subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
            compileSdk = kicscoreCompileSdk

            if (namespace == null) {
                namespace = when (project.name) {
                    "facebook_audience_network" -> facebookAudienceNetworkNamespace
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
