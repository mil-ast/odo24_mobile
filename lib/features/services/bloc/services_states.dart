part of './services_cubit.dart';

class NextODOInformation {
  final double factor;
  final int leftDistance;
  final NextODOInformationColorLevel colorLevel;
  const NextODOInformation(this.leftDistance, this.factor, this.colorLevel);

  String toStringLeftDistancePercent() {
    return '${(factor * 100).round()}%';
  }
}

sealed class ServicesState {
  const ServicesState();

  bool get needBuild => switch (this) {
    ServicesLoadingState() => true,
    ServicesFailureState() => false,
    ServicesShowListState() => true,
    ServicesActionShowCreateDialogState() => false,
    ServicesActionShowUpdateDialogState() => false,
    ServicesActionShowDeleteConfirmationDialogState() => false,
    ServicesCreateSuccessState() => false,
    ServicesUpdateSuccessState() => false,
    ServicesUpdateDeleteState() => false,
    ServiceCarODOConfirmState() => false,
  };
}

class ServicesLoadingState extends ServicesState {
  const ServicesLoadingState();
}

class ServicesFailureState extends ServicesState {
  final String message;
  ServicesFailureState(Object err) : message = err.toString();
}

class ServicesShowListState extends ServicesState {
  final List<ServiceModel> services;
  final NextODOInformation? inform;
  const ServicesShowListState({required this.services, required this.inform});
}

class ServicesActionShowUpdateDialogState extends ServicesState {
  final ServiceModel service;
  const ServicesActionShowUpdateDialogState(this.service);
}

class ServicesActionShowDeleteConfirmationDialogState extends ServicesState {
  final ServiceModel service;
  const ServicesActionShowDeleteConfirmationDialogState(this.service);
}

class ServicesActionShowCreateDialogState extends ServicesState {
  const ServicesActionShowCreateDialogState();
}

class ServicesCreateSuccessState extends ServicesState {
  const ServicesCreateSuccessState();
}

class ServicesUpdateSuccessState extends ServicesState {
  const ServicesUpdateSuccessState();
}

class ServicesUpdateDeleteState extends ServicesState {
  const ServicesUpdateDeleteState();
}

class ServiceCarODOConfirmState extends ServicesState {
  ServiceCreateRequestModel body;
  int milleage;
  ServiceCarODOConfirmState({required this.body, required this.milleage});
}
