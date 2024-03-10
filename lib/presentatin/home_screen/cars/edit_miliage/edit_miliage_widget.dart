import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/home_screen/cars/cars_cubit.dart';
import 'package:odo24_mobile/data/repository/cars/models/car_update_dto.dart';
import 'package:odo24_mobile/domain/services/cars/models/car.model.dart';

class EditMiliageWidget extends StatelessWidget {
  final CarModel car;
  EditMiliageWidget(this.car, {super.key});

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;

  @override
  Widget build(BuildContext context) {
    _odoController = TextEditingController.fromValue(TextEditingValue(text: car.odo.toString()));

    return BlocListener<CarsCubit, AppState>(
      listener: (context, state) {
        if (state is CarUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _odoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                helperText: 'Пробег авто, км.',
                icon: Icon(Icons.speed),
              ),
              inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
              validator: (String? input) {
                if (input == null) {
                  return 'Укажите пробег авто';
                }

                int? odo = int.tryParse(input);
                if (odo == null) {
                  return 'Некорретное значение пробега';
                } else if (odo > 9999999) {
                  return 'Слишком большой пробег';
                }

                return null;
              },
            ),
            Wrap(
              children: [50, 100, 200, 500, 1000]
                  .map((v) => TextButton(
                        onPressed: () {
                          _addMiliage(v);
                        },
                        child: Text('+$vкм'),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Закрыть'),
                ),
                ElevatedButton(
                  child: const Text('Сохранить'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                      return;
                    }

                    context.read<CarsCubit>().update(
                          car,
                          CarUpdateDTO(
                            carID: car.carID,
                            name: car.name,
                            odo: int.parse(_odoController.text),
                            avatar: false,
                          ),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addMiliage(int miliage) {
    final currentValue = int.tryParse(_odoController.text);
    if (currentValue == null) {
      return;
    }

    _odoController.text = '${currentValue + miliage}';
  }
}
