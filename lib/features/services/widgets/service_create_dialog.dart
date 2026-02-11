import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';

class ServiceCreateWidget extends StatefulWidget {
  final CarModel selectedCar;
  final GroupModel selectedGroup;
  const ServiceCreateWidget({required this.selectedCar, required this.selectedGroup, super.key});

  @override
  State<ServiceCreateWidget> createState() => _ServiceCreateWidgetState();
}

class _ServiceCreateWidgetState extends State<ServiceCreateWidget> {
  static const _defaultNextDistanceValue = 10000;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;
  late final TextEditingController _nextDistanceController;
  late final TextEditingController _dtController;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _odoController = TextEditingController.fromValue(TextEditingValue(text: widget.selectedCar.odo.toString()));
    _nextDistanceController = TextEditingController.fromValue(
      TextEditingValue(text: _defaultNextDistanceValue.toString()),
    );
    _dtController = TextEditingController.fromValue(
      TextEditingValue(text: DateTime.now().toIso8601String().substring(0, 10)),
    );
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
      child: SingleChildScrollView(
        child: BlocListener<ServicesCubit, ServicesState>(
          bloc: context.read<ServicesCubit>(),
          listener: (context, state) {
            if (state is ServicesCreateSuccessState) {
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
                      child: const Text('Добавить'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Проверьте правильность заполнения формы')));
                          return;
                        }

                        final body = ServiceCreateRequestModel(
                          odo: _odoController.text.isNotEmpty ? int.parse(_odoController.text) : null,
                          nextDistance: _nextDistanceController.text.isNotEmpty
                              ? int.parse(_nextDistanceController.text)
                              : null,
                          dt: _dtController.text,
                          description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                          price: _priceController.text.isNotEmpty ? int.parse(_priceController.text) : null,
                        );
                        context.read<ServicesCubit>().create(body);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
