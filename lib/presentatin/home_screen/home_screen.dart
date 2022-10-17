import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/cars/car_item_screen.dart';
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
    );
  }

  Widget _buildContent() {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: BlocConsumer<HomeCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          return StreamBuilder(
            stream: context.read<HomeCubit>().getAllCars(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (!snap.hasData) {
                return Text('Нет данных');
              }

              return Column(
                children: snap.data!.docs.map((car) => _buildCar(context, car)).toList(),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildCar(BuildContext context, QueryDocumentSnapshot<Object?> car) {
    return Card(
      elevation: 6,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ListTile(
                leading: const Icon(Icons.directions_car_sharp),
                title: Text(car.get('name')),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return CarItemScreen(car);
                  }));
                },
              ),
            ),
            PopupMenuButton(
              elevation: 10,
              shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1)),
              icon: Icon(Icons.more_vert),
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Icon(Icons.edit),
                      Text('Изменить'),
                    ],
                  ),
                  onTap: () {
                    //context.read<ServicesCubit>().onClickOpenEditDialog(service);
                  },
                ),
                PopupMenuItem(
                  child: Wrap(
                    spacing: 10,
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      Text(
                        'Удалить',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                  onTap: () {
                    //context.read<ServicesCubit>().delete(service);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );

    return Card(
      child: Row(
        children: [
          ListTile(
            leading: const Icon(Icons.time_to_leave),
            title: Text(car.get('name')),
            subtitle: Text('Пробег ${car.get('odo')}'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return CarItemScreen(car);
              }));
            },
          ),
          PopupMenuButton(
            elevation: 10,
            shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1)),
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.edit),
                    Text('Изменить'),
                  ],
                ),
                onTap: () {
                  //context.read<ServicesCubit>().onClickOpenEditDialog(service);
                },
              ),
              PopupMenuItem(
                child: Wrap(
                  spacing: 10,
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    Text(
                      'Удалить',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                onTap: () {
                  //context.read<ServicesCubit>().delete(service);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
