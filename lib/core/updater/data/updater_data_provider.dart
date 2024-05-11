import 'package:dio/dio.dart';
import 'package:odo24_mobile/core/http/response_handler.dart';
import 'package:odo24_mobile/core/updater/data/models/apk_metadata_model.dart';

abstract interface class IUpdaterDataProvider {
  Future<ApkMetadataModel> getVersionMetadata();
}

class UpdaterDataProvider implements IUpdaterDataProvider {
  final Dio _httpClient;

  UpdaterDataProvider({
    required Dio httpClient,
  }) : _httpClient = httpClient;

  @override
  Future<ApkMetadataModel> getVersionMetadata() async {
    final api = _httpClient.get('/apk/output-metadata.json');
    final json = await ResponseHandler.parseJSON(api);
    if (json == null) {
      throw Exception('Ошибка получения метаданных обновления');
    }

    return ApkMetadataModel.fromJson(json);
  }
}
