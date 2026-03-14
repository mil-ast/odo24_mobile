import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';
import 'package:odo24_mobile/data/auth/auth_service.dart';

base class StatusCodeMiddleware extends Middleware {
  const StatusCodeMiddleware();

  @override
  Future<StreamedResponse> execute(BaseRequest request, NextFunction next) async {
    var response = await next(request);
    if (response.statusCode == HttpStatus.unauthorized) {
      AuthService.instance.logout();
      return response;
    }
    if (response.statusCode >= HttpStatus.badRequest) {
      final bytes = await response.stream.toBytes();
      final bodyString = utf8.decode(bytes);
      throw AppNetworkException(
        'ResponseError',
        bodyString,
        details: '${request.url}',
        statusCode: response.statusCode,
      );
    }

    return response;
  }
}
