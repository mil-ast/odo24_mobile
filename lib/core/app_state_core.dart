import 'package:dio/dio.dart';

abstract class AppState {
  static AppStateError catchErrorHandler(Object error, {String? details}) {
    if (error is AppStateError) {
      return error;
    } else if (error is DioError) {
      return AppStateError('dioError', error.message ?? error.toString(), details: details);
    } else if (error is TypeError) {
      return AppStateError('typeError', error.toString(), details: details);
    }

    return AppStateError('unidentified error', error.toString(), details: details);
  }
}

class AppStateError extends AppState {
  String key;
  String error;
  String? details;

  AppStateError(this.key, this.error, {this.details});
}

class AppStateSuccess<T> extends AppState {
  T? data;

  AppStateSuccess([this.data]);

  bool isEmpty() {
    return data == null;
  }
}

class AppStateDefault extends AppState {}

class AppStateLoading extends AppState {}
