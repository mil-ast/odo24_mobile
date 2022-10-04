import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/services/cars_service.dart';
import 'package:odo24_mobile/presentatin/cars/car_item_screen.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/car/car_create_widget.dart';
import 'package:odo24_mobile/presentatin/home_screen/home_cubit.dart';
import 'package:odo24_mobile/presentatin/login_screen/login_screen.dart';
import 'package:odo24_mobile/services/auth/auth_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('ODO24 Сервисная книжка авто'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Домашняя главная страница'),
              _buildContent(),
              OutlinedButton(
                child: Text('Выход'),
                onPressed: () async {
                  await AuthService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return BlocProvider(
      create: (_) => HomeCubit()..getAllCars(),
      child: BlocConsumer<HomeCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is HomeCarStateSuccess) {
            return; // TODO
            if (state.cars.length == 1) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CarItemScreen(state.cars.first),
                ),
              );
            }
          }
        },
        builder: (BuildContext context, AppState state) {
          if (state is HomeCreateFirstCarState) {
            return CarCreateWidget();
          }

          if (state is HomeCarStateSuccess) {
            return StreamBuilder(
              stream: CarsService().listener,
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<CarModel>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snap.hasData) {
                  return Text('Нет данных');
                }

                return Column(
                  children: snap.data!.docs.map((QueryDocumentSnapshot<CarModel> car) => _buildCar(context, car)).toList(),
                );
              },
            );
          }

          return const Center(
            child: Text('Непонятный стейт'),
          );
        },
      ),
    );
  }

  Widget _buildCar(BuildContext context, QueryDocumentSnapshot<CarModel> car) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.time_to_leave),
            title: Text(car.get('name')),
            subtitle: Text('Пробег ${car.get('odo')}'),
            onTap: () {
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CarItemScreen(car),
                ),
              );*/

              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
                return CarItemScreen(car);
              }));
            },
          ),
        ],
      ),
    );
  }
}
