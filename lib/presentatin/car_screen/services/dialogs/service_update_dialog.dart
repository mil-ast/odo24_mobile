import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/services/services_cubit.dart';
import 'package:odo24_mobile/repository/services/models/service_update_request_model.dart';
import 'package:odo24_mobile/services/services/models/service_result_model.dart';

class ServiceRecUpdateWidget extends StatelessWidget {
  final ServiceModel service;
  final ServicesCubit servicesCubit;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;
  late final TextEditingController _nextDistanceController;
  late final TextEditingController _dtController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  ServiceRecUpdateWidget(
    this.servicesCubit, {
    required this.service,
    super.key,
  }) {
    _odoController = TextEditingController.fromValue(
      TextEditingValue(text: service.odo.toString()),
    );
    _nextDistanceController = TextEditingController.fromValue(
      TextEditingValue(text: '${service.nextDistance ?? ''}'),
    );
    _dtController = TextEditingController.fromValue(
      TextEditingValue(text: service.dt.toIso8601String().substring(0, 10)),
    );
    _descriptionController = TextEditingController.fromValue(
      TextEditingValue(text: service.description ?? ''),
    );
    _priceController = TextEditingController.fromValue(
      TextEditingValue(text: '${service.price ?? ''}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServicesCubit, AppState>(
      bloc: servicesCubit,
      listener: (context, state) {
        if (state is ServiceUpdateSuccessful) {
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

                    final body = ServiceUpdateRequestModel(
                      odo: _odoController.text.isNotEmpty ? int.parse(_odoController.text) : null,
                      nextDistance:
                          _nextDistanceController.text.isNotEmpty ? int.parse(_nextDistanceController.text) : null,
                      dt: _dtController.text,
                      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                      price: _priceController.text.isNotEmpty ? int.parse(_priceController.text) : null,
                    );
                    servicesCubit.update(service, body);
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
