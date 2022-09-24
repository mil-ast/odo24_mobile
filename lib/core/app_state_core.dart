class AppState {}

class AppStateError extends AppState {
  String key;
  String error;
  String? details;

  AppStateError(this.key, this.error, {this.details});
}
