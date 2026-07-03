pluginManagement {
    def flutterSdkPath = {
        def flutterRoot = System.env.FLUTTER_ROOT
        if (flutterRoot) {
            return flutterRoot
        }

        def flutterProperties = new File(rootDir.parentFile, ".flutter-config")
        if (flutterProperties.exists()) {
            def properties = new Properties()
            properties.load(new FileInputStream(flutterProperties))
            return properties.getProperty("flutter.sdk")
        }

        throw new GradleException(
            "Flutter SDK not found. Define location with flutter.sdk in the local" +
            " properties file or use \$FLUTTER_ROOT environment variable."
        )
    }()

    settings.ext.flutterSdkPath = flutterSdkPath
    includeBuild("${flutterSdkPath}/packages/flutter_tools/gradle")
}

plugins {
    id "dev.flutter.flutter-plugin-loader" version "1.0.0"
    id "com.android.application" version "8.1.0" apply false
    id "org.jetbrains.kotlin.android" version "1.7.10" apply false
}

include ":app"
