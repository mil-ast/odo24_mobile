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

/* {
  "version": 3,
  "artifactType": {
    "type": "APK",
    "kind": "Directory"
  },
  "applicationId": "ru.odo24.mobile",
  "variantName": "release",
  "elements": [
    {
      "type": "UNIVERSAL",
      "filters": [],
      "attributes": [],
      "versionCode": 3,
      "versionName": "2.2.0",
      "outputFile": "app-universal-release.apk"
    },
    {
      "type": "ONE_OF_MANY",
      "filters": [
        {
          "filterType": "ABI",
          "value": "x86_64"
        }
      ],
      "attributes": [],
      "versionCode": 3,
      "versionName": "2.2.0",
      "outputFile": "app-x86_64-release.apk"
    },
    {
      "type": "ONE_OF_MANY",
      "filters": [
        {
          "filterType": "ABI",
          "value": "armeabi-v7a"
        }
      ],
      "attributes": [],
      "versionCode": 3,
      "versionName": "2.2.0",
      "outputFile": "app-armeabi-v7a-release.apk"
    },
    {
      "type": "ONE_OF_MANY",
      "filters": [
        {
          "filterType": "ABI",
          "value": "arm64-v8a"
        }
      ],
      "attributes": [],
      "versionCode": 3,
      "versionName": "2.2.0",
      "outputFile": "app-arm64-v8a-release.apk"
    }
  ],
  "elementType": "File"
} */