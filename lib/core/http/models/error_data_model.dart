class ErrorDataModel {
  final String key;
  final String message;

  const ErrorDataModel(
    this.key,
    this.message,
  );

  factory ErrorDataModel.fromJson(Map<String, dynamic> json) => ErrorDataModel(
        json['key'] as String,
        json['message'] as String,
      );
}
