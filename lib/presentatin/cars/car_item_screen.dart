import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class CarItemScreen extends StatelessWidget {
  final QueryDocumentSnapshot<CarModel> carDoc;
  const CarItemScreen(this.carDoc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(carDoc.get('name')),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.green,
            height: 80,
            child: Text('fff'),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text('Моя машина'),
                        OutlinedButton(
                          child: Text('Выход'),
                          onPressed: () {
                            AuthService.logout();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 400),
                  Container(
                    color: Colors.amber,
                    height: 400,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
