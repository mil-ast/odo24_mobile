import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';
import 'package:odo24_mobile/features/cars/data/models/car_update_request_model.dart';

class CarEditDialog extends StatefulWidget {
  final CarModel car;

  const CarEditDialog({required this.car, super.key});

  @override
  State<StatefulWidget> createState() => _CarEditState();
}

class _CarEditState extends State<CarEditDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _odoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController.fromValue(
      TextEditingValue(text: widget.car.name),
    );
    _odoController = TextEditingController.fromValue(
      TextEditingValue(text: widget.car.odo.toString()),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarsCubit, CarsState>(
      listener: (context, state) {
        if (state is CarUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: FormDialogCard(
        formKey: _formKey,
        icon: Icons.directions_car_filled_rounded,
        title: 'Изменить автомобиль',
        description: 'Обновите название или текущий пробег автомобиля.',
        children: [
          TextFormField(
            controller: _nameController,
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Название автомобиля',
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
          FormDialogActions(
            submitLabel: 'Сохранить',
            submitIcon: Icons.save_outlined,
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

    final body = CarUpdateRequestModel(
      carID: widget.car.carID,
      name: _nameController.text.trim(),
      odo: int.parse(_odoController.text),
      avatar: false,
    );
    context.read<CarsCubit>().edit(body);
  }
}
