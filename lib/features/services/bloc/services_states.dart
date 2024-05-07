import 'package:odo24_mobile/features/services/data/models/service_model.dart';

sealed class ServicesState {
  final bool needBuild;
  const ServicesState(this.needBuild);

  factory ServicesState.ready() = ServicesReadyState;
  factory ServicesState.idle() = ServicesLoadingState;
  factory ServicesState.showList(List<ServiceModel> services) = ServicesShowListState;
}

class ServicesReadyState extends ServicesState {
  const ServicesReadyState() : super(true);
}

class ServicesLoadingState extends ServicesState {
  const ServicesLoadingState() : super(true);
}

class ServicesShowListState extends ServicesState {
  final List<ServiceModel> services;
  const ServicesShowListState(this.services) : super(true);
}
