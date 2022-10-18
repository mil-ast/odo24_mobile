import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/create/car_create_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/cars/create/models/car_create_dto.dart';

class CarCreateWidget extends StatelessWidget {
  CarCreateWidget({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _odoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CarCreateCubit(),
      child: BlocConsumer<CarCreateCubit, AppState>(
        listener: (context, state) {
          if (state is AppStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Произошла ошибка'),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          } else if (state is AppStateSuccess) {
            Navigator.of(context).pop();
          }
        },
        buildWhen: (AppState previous, AppState current) {
          return current is! AppStateError;
        },
        builder: (BuildContext context, AppState state) {
          return Form(
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

                        final body = CarCreateDTO(
                          uid: ProficeServicesCore.userID,
                          name: _nameController.text.trim(),
                          odo: int.parse(_odoController.text),
                          withAvatar: false,
                        );
                        context.read<CarCreateCubit>().create(body);
                      },
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Закрыть'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
