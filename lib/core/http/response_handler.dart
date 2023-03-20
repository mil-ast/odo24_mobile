import 'package:dio/dio.dart';

class ResponseHandler {
  static parse(Response<dynamic> res) {
    switch (res.statusCode) {
      case 200:
        if (res.data is List) {
          return List.from(res.data);
        }
        return res.data;
      case 204:
        return null;
    }
  }
}
