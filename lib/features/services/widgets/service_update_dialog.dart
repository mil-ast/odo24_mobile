import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_model.dart';
import 'package:odo24_mobile/features/services/data/models/service_update_request_model.dart';

class ServiceUpdateDialog extends StatefulWidget {
  final ServiceModel service;
  final GroupModel selectedGroup;
  const ServiceUpdateDialog({required this.service, required this.selectedGroup, super.key});

  @override
  State<ServiceUpdateDialog> createState() => _ServiceUpdateDialogState();
}

class _ServiceUpdateDialogState extends State<ServiceUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;
  late final TextEditingController _nextDistanceController;
  late final TextEditingController _dtController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _odoController = TextEditingController.fromValue(TextEditingValue(text: widget.service.odo.toString()));
    _nextDistanceController = TextEditingController.fromValue(
      TextEditingValue(text: '${widget.service.nextDistance ?? ''}'),
    );
    _dtController = TextEditingController.fromValue(
      TextEditingValue(text: widget.service.dt.toIso8601String().substring(0, 10)),
    );
    _descriptionController = TextEditingController.fromValue(TextEditingValue(text: widget.service.description ?? ''));
    _priceController = TextEditingController.fromValue(TextEditingValue(text: '${widget.service.price ?? ''}'));
  }

  @override
  void dispose() {
    _odoController.dispose();
    _nextDistanceController.dispose();
    _dtController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      title: AppCardTitle(title: widget.selectedGroup.name),
      child: BlocListener<ServicesCubit, ServicesState>(
        listener: (context, state) {
          if (state is ServicesUpdateSuccessState) {
            Navigator.pop(context);
          }
        },
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            children: [
              TextFormField(
                controller: _odoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(helperText: 'Пробег, км', icon: Icon(Icons.speed)),
                validator: (String? name) {
                  return null;
                },
              ),
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
              TextFormField(
                controller: _dtController,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(helperText: 'Дата обслуживания', icon: Icon(Icons.date_range)),
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
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: 10,
                minLines: 2,
                decoration: const InputDecoration(helperText: 'Комментарий', icon: Icon(Icons.comment)),
                validator: (String? name) {
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(helperText: 'Стоимость', icon: Icon(Icons.money)),
                validator: (String? name) {
                  return null;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
                  const SizedBox(width: 20),
                  FilledButton(
                    child: const Text('Сохранить'),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Проверьте правильность заполнения формы')));
                        return;
                      }

                      final body = ServiceUpdateRequestModel(
                        odo: _odoController.text.isNotEmpty ? int.tryParse(_odoController.text) : null,
                        nextDistance: _nextDistanceController.text.isNotEmpty
                            ? int.tryParse(_nextDistanceController.text)
                            : null,
                        dt: _dtController.text,
                        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                        price: _priceController.text.isNotEmpty ? int.tryParse(_priceController.text) : null,
                      );
                      context.read<ServicesCubit>().update(serviceID: widget.service.serviceID, body: body);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
