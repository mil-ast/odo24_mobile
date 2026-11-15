import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/services/bloc/services_cubit.dart';
import 'package:odo24_mobile/features/services/data/models/service_create_request_model.dart';

class ServiceCreateWidget extends StatefulWidget {
  final CarModel selectedCar;
  final GroupModel selectedGroup;

  const ServiceCreateWidget({
    required this.selectedCar,
    required this.selectedGroup,
    super.key,
  });

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
    _odoController = TextEditingController.fromValue(
      TextEditingValue(text: widget.selectedCar.odo.toString()),
    );
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
    return BlocListener<ServicesCubit, ServicesState>(
      listener: (context, state) {
        if (state is ServicesCreateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: FormDialogCard(
        formKey: _formKey,
        icon: Icons.build_rounded,
        title: 'Новая запись',
        description: 'Группа «${widget.selectedGroup.name}»',
        children: [
          TextFormField(
            controller: _odoController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Пробег',
              prefixIcon: Icon(Icons.speed_rounded),
              suffixText: 'км',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? value) => null,
          ),
          TextFormField(
            controller: _nextDistanceController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Следующее обслуживание через',
              prefixIcon: Icon(Icons.update_rounded),
              suffixText: 'км',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? value) => null,
          ),
          TextFormField(
            controller: _dtController,
            keyboardType: TextInputType.datetime,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Дата обслуживания',
              hintText: 'ГГГГ-ММ-ДД',
              prefixIcon: Icon(Icons.event_outlined),
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
            validator: (String? value) => null,
          ),
          TextFormField(
            controller: _descriptionController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 20,
            minLines: 3,
            decoration: const InputDecoration(
              labelText: 'Комментарий',
              hintText: 'Что сделали и какие детали использовали',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_rounded),
            ),
            validator: (String? value) => null,
          ),
          TextFormField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Стоимость',
              prefixIcon: Icon(Icons.payments_outlined),
              suffixText: '₽',
            ),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
            validator: (String? value) => null,
            onFieldSubmitted: (_) => _submit(),
          ),
          FormDialogActions(
            submitLabel: 'Добавить',
            submitIcon: Icons.add_rounded,
            onCancel: Navigator.of(context).pop,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Проверьте правильность заполнения формы'),
        ),
      );
      return;
    }

    final body = ServiceCreateRequestModel(
      odo: _odoController.text.isNotEmpty
          ? int.parse(_odoController.text)
          : null,
      nextDistance: _nextDistanceController.text.isNotEmpty
          ? int.parse(_nextDistanceController.text)
          : null,
      dt: _dtController.text,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
      price: _priceController.text.isNotEmpty
          ? int.parse(_priceController.text)
          : null,
    );
    context.read<ServicesCubit>().create(body);
  }
}
