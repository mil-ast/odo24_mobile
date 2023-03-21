import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/car_list_screen.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/cars_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/create/car_create_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/update/car_update_widget.dart';
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
        actions: [
          IconButton(
            onPressed: () async {
              AuthService().logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      //body: CarListScreen(),
      body: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => CarsCubit()),
          ],
          child: BlocConsumer<CarsCubit, AppState>(
            listener: (context, state) {
              if (state is OnUpdateCarState) {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    insetPadding: EdgeInsets.all(20),
                    contentPadding: EdgeInsets.all(20),
                    title: Text('Редактировать авто'),
                    children: [
                      CarUpdateWidget(state.car),
                    ],
                  ),
                );
              }
            },
            builder: (context, state) => CarListScreen(),
          )
          /* builder: (context, state) => StreamBuilder(
            stream: context.read<CarsCubit>().getAllCars(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (!snap.hasData) {
                return Text('Нет данных');
              }

              final docs = snap.data!.docs;

              if (docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Добавьте ваш первый авто',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      CarCreateWidget(isEmbedded: true),
                    ],
                  ),
                );
              }

              return Column(
                children: docs.map((car) {
                  return _buildCar(context, car);
                }).toList(),
              );
            },
          ),
        ), */
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
                subtitle: Text('Пробег ${car.get('odo')} км'),
                onTap: () {
                  /* Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return CarItemScreen(car);
                  })); */
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
                    context.read<CarsCubit>().onClickUpdateCar(car);
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
                    context.read<CarsCubit>().onClickDeleteCar(car);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
