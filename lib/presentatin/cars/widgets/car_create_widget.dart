import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/car_create_cubit.dart';

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
                  autofocus: true,
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
                  autofocus: true,
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
                ElevatedButton(
                  child: Text('Сохранить'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                    }

                    final odo = int.parse(_odoController.text);
                    final car = CarModel(_nameController.text, odo, withAvatar: false);

                    context.read<CarCreateCubit>().create(car);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
