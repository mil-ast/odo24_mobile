import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/app_exception.dart';

class FileLoader {
  FileLoader({
    required this.fileURL,
    required this.saveToPath,
  }) {
    loadStream = _loadStreamController.stream.asBroadcastStream();
  }

  final String fileURL;
  final String saveToPath;

  final _loadStreamController = StreamController<double>(); //поток загрузки в диапозоне от 0 до 1
  late final Stream<double> loadStream;
  final _cancelToken = CancelToken();

  final _dio = Dio(
    BaseOptions(
      receiveTimeout: const Duration(minutes: 20),
      validateStatus: (status) => status != null,
    ),
  );

  Future<void> loadFile() async {
    final result = await _dio.download(
      fileURL,
      saveToPath,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
      ),
      deleteOnError: true,
      cancelToken: _cancelToken,
      onReceiveProgress: (int count, int total) {
        if (_loadStreamController.isClosed) {
          return;
        }
        _loadStreamController.add(count / total);
        if (count == total) {
          _loadStreamController.close();
        }
      },
    );
    if (result.statusCode != HttpStatus.ok) {
      throw AppException(
        'Ошибка загрузки файла',
        details: 'status: ${result.statusMessage ?? result.statusCode}',
      );
    }
    Process.runSync('chmod', ['u+x', saveToPath]);
  }

  void cancelLoading() {
    _cancelToken.cancel();
    _loadStreamController.close();
  }
}
