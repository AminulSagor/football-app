# Facebook Audience Network 6.x references these annotation-only classes.
# They are not required at runtime, but R8 treats the missing annotations as an error in release builds.
-dontwarn com.facebook.infer.annotation.**
-keep class com.facebook.infer.annotation.** { *; }
-keepattributes RuntimeVisibleAnnotations,RuntimeInvisibleAnnotations,AnnotationDefault
