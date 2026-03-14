# Сохраняем все классы Google Play Services и ML Kit
-keep class com.google.android.gms.** { *; }
-keep class com.google.mlkit.** { *; }

# Предотвращаем удаление нативных методов
-keepclasseswithmembernames class * {
    native <methods>;
}

# Если используете текстовое распознавание
-keep class com.google.android.libraries.barhopper.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_text_common.** { *; }

# Подавляем ошибки отсутствующих классов
-dontwarn com.google.android.gms.**
-dontwarn com.google.mlkit.**
