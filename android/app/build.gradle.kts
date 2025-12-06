import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// Load keystore properties if available
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.weatherspinner.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.weatherspinner.app"
        // Explicitly set minSdk to 23 to satisfy Play Store / build requirements
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            if (keystorePropertiesFile.exists()) {
                val storeFileProperty = keystoreProperties.getProperty("storeFile")
                val keyAliasProperty = keystoreProperties.getProperty("keyAlias")
                val keyPasswordProperty = keystoreProperties.getProperty("keyPassword")
                val storePasswordProperty = keystoreProperties.getProperty("storePassword")
                
                if (storeFileProperty != null && keyAliasProperty != null && 
                    keyPasswordProperty != null && storePasswordProperty != null) {
                    // Resolve path relative to android directory (rootProject)
                    val keystoreFile = rootProject.file(storeFileProperty)
                    
                    if (keystoreFile.exists()) {
                        storeFile = keystoreFile
                        keyAlias = keyAliasProperty
                        keyPassword = keyPasswordProperty
                        storePassword = storePasswordProperty
                    }
                }
            }
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
