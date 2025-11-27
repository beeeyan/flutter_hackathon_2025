plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "work.sendfun.hackathon"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets["main"].java.srcDirs("src/main/kotlin")

    defaultConfig {
        applicationId = "work.sendfun.hackathon"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    flavorDimensions += "flavor-type"

    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "アプリ名.dev")
        }
        create("prod") {
            dimension = "flavor-type"
            applicationIdSuffix = ""
            resValue("string", "app_name", "アプリ名")
        }
    }
}

flutter {
    source = "../.."
}
