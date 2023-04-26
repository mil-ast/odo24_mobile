import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/cars_cubit.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/create/car_create_widget.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';

class FormCarCreateWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 40),
          Icon(Icons.comment),
          SizedBox(height: 20),
          Text(
            'Автомобилей ещё нет :(',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 6,
            children: [
              InkWell(
                onTap: () {
                  showDialog<CarModel>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      title: Text('Добавить авто'),
                      children: [
                        CarCreateWidget(isEmbedded: false),
                      ],
                    ),
                  ).then((car) {
                    if (car != null) {
                      context.read<CarsCubit>().onCreateCar(car);
                    }
                  });
                },
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.car_rental, size: 30, color: Odo24App.actionsColor),
                    Text(
                      'Добавить',
                      style: TextStyle(color: Odo24App.actionsColor, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Text(
                'авто',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
