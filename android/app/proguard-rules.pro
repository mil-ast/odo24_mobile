# R8 minification breaks the pigeon-generated "suspend" functions of Flutter
# plugins at runtime. It renames/removes the Kotlin coroutines runtime classes
# these signatures rely on, e.g.:
#   NoSuchMethodError: SharedPreferencesApiRegistrar.getAll(String, List, Continuation)
#   ClassNotFoundException: kotlin.coroutines.intrinsics.CoroutineSingletons
# Keep the Kotlin coroutines runtime and the shared_preferences_android package
# un-obfuscated/un-shrunk so caller and callee signatures stay consistent.
-keep class kotlin.coroutines.** { *; }
-keep class kotlinx.coroutines.** { *; }

-keep class io.flutter.plugins.sharedpreferences.** { *; }