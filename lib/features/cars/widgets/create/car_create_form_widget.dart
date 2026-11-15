import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/data/models/car_create_request_model.dart';

class CarCreateFormWidget extends StatefulWidget {
  const CarCreateFormWidget({super.key});

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
    return FormDialogCard(
      formKey: _formKey,
      icon: Icons.directions_car_filled_rounded,
      title: 'Добавить авто',
      description:
          'Пока нет ни одного автомобиля. Начните вести сервисную книжку — добавьте название и текущий пробег.',
      children: [
        TextFormField(
          controller: _nameController,
          autofocus: true,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Название автомобиля',
            hintText: 'Например, Toyota Camry',
            prefixIcon: Icon(Icons.directions_car_outlined),
          ),
          validator: (String? name) {
            if (name == null || name.trim().length < 3) {
              return 'Название слишком короткое';
            } else if (name.trim().length > 120) {
              return 'Название слишком длинное';
            }
            return null;
          },
        ),
        TextFormField(
          controller: _odoController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(
            labelText: 'Текущий пробег',
            hintText: '0',
            prefixIcon: Icon(Icons.speed_rounded),
            suffixText: 'км',
          ),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (String? input) {
            if (input == null || input.isEmpty) {
              return 'Укажите пробег авто';
            }

            final odo = int.tryParse(input);
            if (odo == null) {
              return 'Некорректное значение пробега';
            } else if (odo > 9999999) {
              return 'Слишком большой пробег';
            }
            return null;
          },
          onFieldSubmitted: (_) => _submit(),
        ),
        const Divider(height: 1, color: Color(0xFFEDEFF2)),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Добавить авто'),
        ),
      ],
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

    context.read<CarsCubit>().create(
      CarCreateRequestModel(
        name: _nameController.text.trim(),
        odo: int.parse(_odoController.text),
        avatar: false,
      ),
    );
  }
}
