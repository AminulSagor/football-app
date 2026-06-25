import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val releaseKeyAlias = keystoreProperties.getProperty("keyAlias")?.trim().orEmpty()
val releaseKeyPassword = keystoreProperties.getProperty("keyPassword")?.trim().orEmpty()
val releaseStoreFile = keystoreProperties.getProperty("storeFile")?.trim().orEmpty()
val releaseStorePassword = keystoreProperties.getProperty("storePassword")?.trim().orEmpty()
val hasReleaseSigningConfig = listOf(
    releaseKeyAlias,
    releaseKeyPassword,
    releaseStoreFile,
    releaseStorePassword,
).all { it.isNotEmpty() }
val isReleaseBuildRequested = gradle.startParameter.taskNames.any {
    it.contains("release", ignoreCase = true)
}

if (isReleaseBuildRequested && !hasReleaseSigningConfig) {
    throw GradleException(
        "Release signing configuration is missing. Add keyAlias, keyPassword, " +
            "storeFile, and storePassword to android/key.properties.",
    )
}

val envProperties = Properties()
val envFile = rootProject.file("../.env")
if (envFile.exists()) {
    envProperties.load(FileInputStream(envFile))
}

fun envValue(key: String): String {
    return envProperties.getProperty(key)?.trim()
        ?: System.getenv(key)?.trim()
        ?: ""
}

fun facebookAppIdResourceValue(): String {
    return envValue("FACEBOOK_APP_ID").removePrefix("fb")
}


android {
    namespace = "com.msunited.kicscore"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.msunited.kicscore"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "facebook_app_id", facebookAppIdResourceValue())
        resValue(
            "string",
            "facebook_client_token",
            envValue("FACEBOOK_CLIENT_TOKEN"),
        )
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    implementation("com.facebook.infer.annotation:infer-annotation:0.18.0")
}
