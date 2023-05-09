import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_cubit.dart';
import 'package:odo24_mobile/repository/services/models/service_create_request_model.dart';
import 'package:odo24_mobile/services/cars/models/car.model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class ServiceRecCreateWidget extends StatelessWidget {
  final CarModel car;
  final GroupModel selectedGroup;
  final ServicesCubit servicesCubit;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;
  late final TextEditingController _nextDistanceController;
  late final TextEditingController _dtController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  ServiceRecCreateWidget(
    this.servicesCubit, {
    required this.car,
    required this.selectedGroup,
    super.key,
  }) {
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, AppState>(
      bloc: servicesCubit,
      listener: (context, state) {
        if (state is ServiceCreateSuccessful) {
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
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
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
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена'),
                ),
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

                    final body = ServiceCreateRequestModel(
                      odo: _odoController.text.isNotEmpty ? int.parse(_odoController.text) : null,
                      nextDistance:
                          _nextDistanceController.text.isNotEmpty ? int.parse(_nextDistanceController.text) : null,
                      dt: _dtController.text,
                      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                      price: _priceController.text.isNotEmpty ? int.parse(_priceController.text) : null,
                    );
                    servicesCubit.create(car, selectedGroup.groupID, body);
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
