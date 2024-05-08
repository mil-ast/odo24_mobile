import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

class CarEditDialog extends StatefulWidget {
  final CarModel car;

  const CarEditDialog({
    required this.car,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CarEditState();
}

class _CarEditState extends State<CarEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _odoController;

  @override
  void dispose() {
    _nameController.dispose();
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController.fromValue(TextEditingValue(text: widget.car.name));
    _odoController = TextEditingController.fromValue(TextEditingValue(text: widget.car.odo.toString()));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменить авто'),
      ),
      body: BlocListener<CarsCubit, CarsState>(
        listener: (context, state) {
          if (state is CarUpdateSuccessState) {
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: Navigator.of(context).pop,
                        child: const Text('Закрыть'),
                      ),
                      const SizedBox(width: 20),
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

                          final body = CarUpdateRequestModel(
                            carID: widget.car.carID,
                            name: _nameController.text.trim(),
                            odo: int.parse(_odoController.text),
                            avatar: false,
                          );
                          context.read<CarsCubit>().edit(body);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
