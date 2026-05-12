# Flutter proguard rules
-keep class io.flutter.** { *; }
-keep class com.google.firebase.** { *; }

# Keep Firebase Auth
-keep class com.google.firebase.auth.** { *; }

# Keep Google Sign-In
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Google Play Core (for dynamic delivery)
-keep class com.google.android.play.core.** { *; }
-keep interface com.google.android.play.core.** { *; }

# Keep Flutter deferred components
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

# Keep all Flutter classes
-keep class io.flutter.plugins.** { *; }

# Keep Dart VM entry point
-keepclasseswithmembernames class ** {
    native <methods>;
}

# Keep enums
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
