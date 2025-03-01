# Keep JavaScript Interface methods
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

-keepattributes JavascriptInterface
-keepattributes *Annotation*

# Keep all Razorpay classes
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }

# Prevent method inlining optimizations that might break Razorpay
-optimizations !method/inlining/*

# Keep classes with payment-related methods
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# Keep proguard.annotation.Keep classes
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Additional fixes
-keep class kotlin.Metadata { *; }
-keep class kotlin.jvm.internal.* { *; }
