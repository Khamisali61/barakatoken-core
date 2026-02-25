# Dio
-keep class dio.** { *; }
-keep class com.dio.** { *; }

# Preserve models
-keep class com.barakatoken.barakatoken_mobile.features.**.domain.** { *; }
-keep class com.barakatoken.barakatoken_mobile.features.**.data.** { *; }

# General Networking and JSON
-keepattributes Signature
-keepattributes *Annotation*
-keep class com.google.gson.** { *; }
-keep class org.json.** { *; }
