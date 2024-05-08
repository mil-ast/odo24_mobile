import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';

class CarCreateFormWidget extends StatefulWidget {
  const CarCreateFormWidget({
    super.key,
  });

  @override
  CarCreateFormState createState() => CarCreateFormState();
}

class CarCreateFormState extends State<CarCreateFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _odoController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Добавьте ваш первый авто',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    hintText: 'Название авто',
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
                const SizedBox(height: 20),
                TextFormField(
                  controller: _odoController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Пробег',
                    helperText: 'км',
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
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 20),
                    FilledButton(
                      child: const Text('Добавить'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Проверьте правильность заполнения формы'),
                            ),
                          );
                          return;
                        }

                        context.read<CarsCubit>().create(
                              CarCreateRequestModel(
                                name: _nameController.text,
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
        ),
      ],
    );
  }
}
