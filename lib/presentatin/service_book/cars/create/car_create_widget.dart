import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/cars_cubit.dart';

class CarCreateWidget extends StatelessWidget {
  final bool isEmbedded;
  final CarsCubit cubit;
  CarCreateWidget(this.cubit, {this.isEmbedded = false, Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _odoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                helperText: 'Название вашего авто',
                icon: Icon(Icons.title),
              ),
              validator: (String? name) {
                if (name == null || name.length < 3) {
                  return 'Название слишком короткое';
                } else if (name.length > 120) {
                  return 'Название слишком длинное';
                }
                return null;
              },
            ),
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
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isEmbedded)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Закрыть'),
                  )
                else
                  SizedBox.shrink(),
                ElevatedButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                      return;
                    }

                    final body = CarModel(
                      uid: ProficeServicesCore.userID,
                      name: _nameController.text.trim(),
                      odo: int.parse(_odoController.text),
                      withAvatar: false,
                    );
                    context.read<CarsCubit>().create(body).then((_) {
                      if (!isEmbedded) {
                        Navigator.of(context).pop();
                      }
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
