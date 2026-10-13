import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:odo24_mobile/core/app_exception.dart';
import 'package:odo24_mobile/core/http/middlewares/middleware.dart';
import 'package:odo24_mobile/core/http/models/error_data_model.dart';
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
      throw await _handleErrorResponse(request, response);
    }

    return response;
  }

  Future<AppNetworkException> _handleErrorResponse(BaseRequest request, StreamedResponse response) async {
    final statusCode = response.statusCode;
    final details = request.url.toString();

    final bytes = await response.stream.toBytes();
    final bodyString = utf8.decode(bytes);

    if (bodyString.isEmpty) {
      return AppNetworkException('HttpResponseRrror', '$statusCode', details: details, statusCode: statusCode);
    }

    final dynamic body;
    try {
      body = jsonDecode(bodyString);
    } on FormatException {
      return AppNetworkException('ResponseError', bodyString, details: details, statusCode: statusCode);
    }

    if (body is Map) {
      final data = ErrorDataModel.fromJson(body.cast<String, Object?>());
      return AppNetworkException(data.key, data.message, statusCode: statusCode);
    }

    return AppNetworkException('ResponseError', bodyString, details: details, statusCode: statusCode);
  }
}
