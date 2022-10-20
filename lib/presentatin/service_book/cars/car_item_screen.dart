import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/update/car_update_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/groups_widget.dart';

class CarItemScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> carDoc;
  const CarItemScreen(this.carDoc, {Key? key}) : super(key: key);

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
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    insetPadding: EdgeInsets.all(20),
                    contentPadding: EdgeInsets.all(20),
                    title: Text('Редактировать авто'),
                    children: [
                      CarUpdateWidget(carDoc),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.edit)),
        ],
      ),
      body: GroupsWidget(carDoc),
    );
  }
}
