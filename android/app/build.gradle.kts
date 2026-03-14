import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

fun Project.loadProperties(fileName: String): Properties = Properties().apply {
    rootProject.file(fileName).let { if (it.exists()) it.inputStream().use { stream -> load(stream) } }
}

val localProperties = loadProperties("local.properties")
val keystoreProperties = loadProperties("key.properties")

android {
    namespace = "ru.odo24.mobile"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_21
        targetCompatibility = JavaVersion.VERSION_21
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_21.toString()
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = "ru.odo24.mobile"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        
        // Оптимизированное чтение версий с дефолтными значениями
        versionCode = localProperties.getProperty("flutter.versionCode")?.toIntOrNull() ?: 1
        versionName = localProperties.getProperty("flutter.versionName") ?: "1.0"
    }

    signingConfigs {
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
            isMinifyEnabled = false // true, если используете R8/ProGuard
            isShrinkResources = false
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }

    splits {
        abi {
            isEnable = true
            reset()
            include("x86_64", "armeabi-v7a", "arm64-v8a")
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
