class AppException implements Exception {
  final String message;
  final String? details;

  const AppException(this.message, {this.details});
}

class AppNetworkException implements Exception {
  final String key;
  final String message;
  final String? details;

  const AppNetworkException(this.key, this.message, {this.details});

  @override
  String toString() {
    var result = '[$key] $message';
    if (details != null) {
      result += '\n$details';
    }
    return result;
  }
}
