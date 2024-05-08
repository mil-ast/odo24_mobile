import 'package:odo24_mobile/features/services/data/models/service_model.dart';

sealed class ServicesState {
  final bool needBuild;
  const ServicesState(this.needBuild);

  factory ServicesState.ready() = ServicesReadyState;
  factory ServicesState.idle() = ServicesLoadingState;
  factory ServicesState.message(String message) = ServiceMessageState;
  factory ServicesState.showList(List<ServiceModel> services) = ServicesShowListState;
  factory ServicesState.actionCreate() => ServiceActionState(ServiceAction.create);
  factory ServicesState.actionUpdate(ServiceModel service) => ServiceActionState(
        ServiceAction.update,
        service: service,
      );
  factory ServicesState.actionDelete(ServiceModel service) => ServiceActionState(
        ServiceAction.delete,
        service: service,
      );
  factory ServicesState.createSuccess() = ServiceCreateSuccessState;
  factory ServicesState.updateSuccess() = ServiceUpdateSuccessState;
  factory ServicesState.deleteSuccess() = ServiceDeleteSuccessState;
}

enum ServiceAction {
  create,
  update,
  delete;
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

class ServiceActionState extends ServicesState {
  final ServiceModel? service;
  final ServiceAction action;
  ServiceActionState(this.action, {this.service}) : super(false);
}

class ServiceCreateSuccessState extends ServicesState {
  const ServiceCreateSuccessState() : super(false);
}

class ServiceUpdateSuccessState extends ServicesState {
  const ServiceUpdateSuccessState() : super(false);
}

class ServiceDeleteSuccessState extends ServicesState {
  const ServiceDeleteSuccessState() : super(false);
}

class ServiceMessageState extends ServicesState {
  final String message;
  ServiceMessageState(this.message) : super(false);
}
