import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/car_item_screen.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/cars_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/create/car_create_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/update/car_update_widget.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class CarListScreen extends StatelessWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('ODO24 Сервисная книжка авто'),
      ),
      body: SingleChildScrollView(
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocProvider(
      create: (_) => CarsCubit(),
      child: BlocConsumer<CarsCubit, AppState>(
        listener: (BuildContext context, AppState state) {
          if (state is OpenUpdateCarDialogState) {
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
          } else if (state is OpenDeleteCarConfirmDialogState) {
            showConfirmationDialog(
              context,
              title: state.car.get('name'),
              message: 'Вы действительно хотите удалить авто?',
              btnNoText: 'Отмена',
              btnOkText: 'Удалить',
            ).then((bool? isOk) {
              if (isOk == true) {
                context.read<CarsCubit>().delete(state.car);
              }
            });
          }
        },
        buildWhen: (previous, current) {
          return current is CarsListResultState || current is AppStateLoading;
        },
        builder: (BuildContext context, AppState state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleToolBarWidget(
                title: 'Мои авто',
                actionButton: IconButton(
                  color: Odo24App.actionsColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        insetPadding: EdgeInsets.all(20),
                        contentPadding: EdgeInsets.all(20),
                        title: Text('Добавить новое авто'),
                        children: [
                          CarCreateWidget(context.read<CarsCubit>()),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              _buildCalListContent(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalListContent(BuildContext context) {
    return StreamBuilder(
      stream: context.read<CarsCubit>().getAllCars(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<CarModel>> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snap.hasData || snap.data!.docs.isEmpty) {
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
                CarCreateWidget(context.read<CarsCubit>(), isEmbedded: true),
              ],
            ),
          );
        }

        final QuerySnapshot<CarModel> data = snap.data!;

        return Column(
          children:
              data.docs.map((QueryDocumentSnapshot<CarModel> queryDoc) => _buildItemCar(context, queryDoc)).toList(),
        );
      },
    );
    /*

    if (state is CarsListResultState) {
      if (state.carList.isEmpty) {
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
        children: state.carList.map((DocumentReference<CarModel> car) => _buildItemCar(context, car)).toList(),
      );*/
  }

  Widget _buildItemCar(BuildContext context, QueryDocumentSnapshot<CarModel> queryDoc) {
    final car = queryDoc.data();
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
                title: Text(car.name),
                subtitle: Text('Пробег ${car.name} км'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return CarItemScreen(queryDoc);
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
                    context.read<CarsCubit>().onClickUpdateCar(queryDoc);
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
                    context.read<CarsCubit>().onClickDeleteCar(queryDoc);
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
