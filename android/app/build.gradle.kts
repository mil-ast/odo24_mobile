import java.util.Properties

plugins {
    id("com.android.application")
    id("dev.flutter.flutter-gradle-plugin")
}

fun Project.loadProperties(fileName: String): Properties =
    Properties().apply {
        rootProject.file(fileName).let { if (it.exists()) it.inputStream().use { stream -> load(stream) } }
    }

val localProperties = loadProperties("local.properties")
val keystoreProperties = loadProperties("key.properties")

android {
    namespace = "ru.odo24.mobile"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = "ru.odo24.mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = 35

        versionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
        versionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

        ndk {
            abiFilters.clear()
            abiFilters.addAll(listOf("armeabi-v7a", "arm64-v8a"))
        }
    }

    signingConfigs {
        getByName("debug") {}

        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storePassword = keystoreProperties.getProperty("storePassword")
            storeFile = keystoreProperties.getProperty("storeFile")?.let { file(it) }
        }
    }

    buildTypes {
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }

        getByName("release") {
            signingConfig = signingConfigs.getByName("release")

            // R8 minification here caused runtime crashes in flutter plugins
            // (shared_preferences_android pigeon `suspend` methods): NoSuchMethodError
            // on SharedPreferencesApiRegistrar.getAll, plus ClassNotFoundException for
            // kotlin.coroutines.intrinsics.CoroutineSingletons and kotlin.Result.
            // Disabling minify/shrink is the reliable fix (small size cost).
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("armeabi-v7a", "arm64-v8a")
            isUniversalApk = true
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Используйте реализацию через строки, если нужно добавить библиотеки
    // implementation("androidx.core:core-ktx:1.12.0")
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}
