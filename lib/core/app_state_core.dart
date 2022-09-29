abstract class AppState {}

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
