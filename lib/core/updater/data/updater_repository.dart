import 'package:odo24_mobile/core/updater/data/models/apk_metadata_model.dart';
import 'package:odo24_mobile/core/updater/data/updater_data_provider.dart';

abstract interface class IUpdaterRepository {
  Future<ApkMetadataModel> getVersionMetadata();
}

class UpdaterRepository implements IUpdaterRepository {
  final IUpdaterDataProvider _dataProvider;

  UpdaterRepository({
    required IUpdaterDataProvider updaterDataProvider,
  }) : _dataProvider = updaterDataProvider;

  @override
  Future<ApkMetadataModel> getVersionMetadata() {
    return _dataProvider.getVersionMetadata();
  }
}
