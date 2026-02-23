import 'package:http/http.dart';

//typedef Middleware = Future<StreamedResponse> Function(BaseRequest request, NextFunction next);

typedef NextFunction = Future<StreamedResponse> Function(BaseRequest request);

abstract base class Middleware {
  const Middleware();

  String get name => runtimeType.toString();

  Future<StreamedResponse> execute(BaseRequest request, NextFunction next);
}
