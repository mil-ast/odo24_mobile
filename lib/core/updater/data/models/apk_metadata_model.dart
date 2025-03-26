class ApkMetadataModel {
  final List<ApkMetadataElementModel> elements;

  const ApkMetadataModel({
    required this.elements,
  });

  factory ApkMetadataModel.fromJson(Map<String, dynamic> json) => ApkMetadataModel(
        elements: (json['elements'] as List).map((e) => ApkMetadataElementModel.fromJson(e)).toList(),
      );
}

class ApkMetadataElementModel {
  final String type;
  final int versionCode;
  final String versionName;
  final String outputFile;

  const ApkMetadataElementModel({
    required this.type,
    required this.versionCode,
    required this.versionName,
    required this.outputFile,
  });

  factory ApkMetadataElementModel.fromJson(Map<String, dynamic> json) => ApkMetadataElementModel(
        type: json['type'] as String,
        versionCode: json['versionCode'] as int,
        versionName: json['versionName'] as String,
        outputFile: json['outputFile'] as String,
      );
}
