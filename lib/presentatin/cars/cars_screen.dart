import 'package:flutter/material.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class CarsScreen extends StatelessWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Мои авто'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Домашняя главная страница'),
              OutlinedButton(
                child: Text('Выход'),
                onPressed: () {
                  AuthService.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
