import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/repository/groups/group_create_request_model.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class FormServiceCreateWidget extends StatelessWidget {
  final CarModel car;
  final GroupModel selectedGroup;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;
  late final TextEditingController _nextDistanceController;
  late final TextEditingController _dtController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  FormServiceCreateWidget(this.car, this.selectedGroup, {super.key}) {
    _odoController = TextEditingController.fromValue(
      TextEditingValue(text: car.odo.toString()),
    );
    _nextDistanceController = TextEditingController.fromValue(
      TextEditingValue(text: 1000.toString()),
    );
    _dtController = TextEditingController.fromValue(
      TextEditingValue(text: DateTime.now().toIso8601String().substring(0, 10)),
    );
  }

  /*   final int serviceID;
  final int? odo;
  final int? nextDistance;
  final String dt;
  final String? description;
  final int? price; */

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.comment),
          const SizedBox(height: 20),
          const Text(
            'Добавьте первую сервисную запись',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Builder(
            builder: (context) => Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _odoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      helperText: 'Пробег, км',
                      icon: Icon(Icons.speed),
                    ),
                    validator: (String? name) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nextDistanceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      helperText: 'Следующее обслуживание через, км',
                      icon: Icon(Icons.speed),
                    ),
                    validator: (String? name) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _dtController,
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      helperText: "Дата обслуживания",
                      icon: Icon(Icons.date_range),
                    ),
                    onTap: () async {
                      FocusScope.of(context).requestFocus(FocusNode());

                      final dt = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (dt != null) {
                        _dtController.text = dt.toIso8601String().substring(0, 10);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _descriptionController,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      helperText: 'Комментарий',
                      icon: Icon(Icons.comment),
                    ),
                    validator: (String? name) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      helperText: 'Стоимость',
                      icon: Icon(Icons.money),
                    ),
                    validator: (String? name) {
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
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

                          /* final body = GroupCreateRequestModel(
                            name: _nameController.text.trim(),
                          );
                          context.read<GroupsCubit>().create(body); */
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
