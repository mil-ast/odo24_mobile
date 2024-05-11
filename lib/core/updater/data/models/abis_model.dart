enum SupportedABIs {
  x86_64('x86_64'),
  arm64V8a('arm64-v8a'),
  armeabiV7a('armeabi-v7a'),
  universal('universal');

/* app-arm64-v8a-release.apk
app-armeabi-v7a-release.apk
app-universal-release.apk
app-x86_64-release.apk */

  final String value;

  const SupportedABIs(this.value);

  factory SupportedABIs.fromString(String? value) {
    if (value == null) {
      return SupportedABIs.universal;
    }
    return SupportedABIs.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SupportedABIs.universal,
    );
  }
}
