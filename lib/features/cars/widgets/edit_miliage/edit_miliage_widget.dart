import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class EditMiliageWidget extends StatefulWidget {
  final CarModel car;

  const EditMiliageWidget(this.car, {super.key});

  @override
  State<EditMiliageWidget> createState() => _EditMiliageWidgetState();
}

class _EditMiliageWidgetState extends State<EditMiliageWidget> {
  static const _quickAddValues = [10, 50, 100, 200, 500, 1000];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _odoController;

  @override
  void initState() {
    super.initState();
    _odoController = TextEditingController.fromValue(
      TextEditingValue(text: widget.car.odo.toString()),
    );
  }

  @override
  void dispose() {
    _odoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<CarsCubit, CarsState>(
      listener: (context, state) {
        if (state is CarUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: FormDialogCard(
        formKey: _formKey,
        icon: Icons.speed_rounded,
        title: 'Пробег автомобиля',
        description: widget.car.name,
        children: [
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: [
              Text(
                'Быстрое добавление',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.black54,
                ),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAddValues
                    .map(
                      (value) => ActionChip(
                        onPressed: () => _addMiliage(value),
                        backgroundColor: const Color(0xFFF7F8FA),
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        label: Text('+${value.toString()} км'),
                        labelStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
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

    final newODO = int.parse(_odoController.text);
    context.read<CarsCubit>().updateODO(widget.car.carID, newODO);
  }

  void _addMiliage(int miliage) {
    final currentValue = int.tryParse(_odoController.text);
    if (currentValue == null) {
      return;
    }

    _odoController.text = '${currentValue + miliage}';
  }
}
