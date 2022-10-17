import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/services_core.dart';

class HomeCubit extends Cubit<AppState> {
  HomeCubit() : super(AppStateDefault());

  Stream<QuerySnapshot> getAllCars() {
    return FirebaseFirestore.instance
        .collection('cars')
        .where('uid', isEqualTo: ProficeServicesCore.userID)
        .snapshots();
  }
}

class HomeCreateFirstCarState extends AppState {}
