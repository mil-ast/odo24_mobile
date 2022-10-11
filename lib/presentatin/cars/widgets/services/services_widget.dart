import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';
import 'package:odo24_mobile/domain/models/services/service_model.dart';
import 'package:odo24_mobile/domain/services/groups_service.dart';
import 'package:odo24_mobile/domain/services/services_service.dart';

class ServicesWidget extends StatelessWidget {
  final QueryDocumentSnapshot<CarModel> carDoc;
  final QueryDocumentSnapshot<GroupModel> group;
  ServicesWidget(this.carDoc, this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(carDoc.get('name')),
            Text(
              'Пробег ${carDoc.get('odo')} км',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(group.get('name')),
            StreamBuilder(
                stream: GroupsService().getServicesByCar(carDoc, group),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<ServiceModel>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snap.hasData) {
                    return Text('Нет данных');
                  }

                  return Column(
                    children: snap.data!.docs.map((QueryDocumentSnapshot<ServiceModel> service) {
                      return Text(service.get('comment'));
                    }).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  /*return SingleChildScrollView(
      child: Column(
        children: [
          Text('Services'),
          FutureBuilder(
              future: ServicesService().getAllServicesByCar(carDoc.reference),
              builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<ServiceModel>>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snap.hasData) {
                  return Text('Нет данных');
                }

                return Column(
                  children: snap.data!.map((QueryDocumentSnapshot<ServiceModel> service) {
                    final DocumentReference groupRef = service.get('group_ref');
                    groupRef.snapshots().forEach((element) {
                      print(element.get('name'));
                    });
                    return Text(service.get('comment'));
                  }).toList(),
                );
              }),
        ],
      ),
    );*/
}
