import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;

/// Определяет, является ли ошибка "сетевой" - то есть такой, при которой имеет смысл
/// автоматически переключиться на резервный хост.
///
/// Сетевые ошибки: таймауты, ошибки резолва DNS, разрыв/сброс соединения.
/// Не-сетевые ошибки (например, TLS/Handshake или ответы сервера 4xx/5xx) переключение НЕ вызывают.
bool isRetriableNetworkError(Object error) {
  return error is TimeoutException ||
      error is SocketException || // покрывает DNS-резолв, refuse, reset / обрыв
      error is OSError ||
      error is HttpException ||
      error is http.ClientException;
}
