/* typedef APKVersion = ({
  String versionName,
  int versionCode,
}); */

class APKVersionModel {
  final String versionName;
  final int versionCode;

  const APKVersionModel({
    required this.versionCode,
    required this.versionName,
  });
}
