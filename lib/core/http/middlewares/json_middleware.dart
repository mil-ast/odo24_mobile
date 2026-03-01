import 'package:http/http.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';

base class JsonContentTypeMiddleware extends Middleware {
  const JsonContentTypeMiddleware();

  @override
  Future<StreamedResponse> execute(BaseRequest request, NextFunction next) async {
    request.headers['content-type'] = 'application/json; charset=utf-8';
    request.headers['accept'] = 'application/json';
    return await next(request);
  }
}
