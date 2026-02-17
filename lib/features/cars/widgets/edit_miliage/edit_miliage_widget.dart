import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/data/models/car_model.dart';

class EditMiliageWidget extends StatelessWidget {
  final CarModel car;
  EditMiliageWidget(this.car, {super.key})
    : _odoController = TextEditingController.fromValue(TextEditingValue(text: car.odo.toString()));

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _odoController;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CarsCubit, CarsState>(
      listener: (context, state) {
        if (state is CarUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: AppCard(
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(car.name, style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                controller: _odoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(helperText: 'Пробег авто, км.', icon: Icon(Icons.speed)),
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
              Wrap(
                spacing: 20,
                children: [10, 50, 100, 200, 500, 1000]
                    .map(
                      (v) => OutlinedButton(
                        onPressed: () {
                          _addMiliage(v);
                        },
                        child: Text('+$vкм'),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: 20,
                children: [
                  TextButton(onPressed: Navigator.of(context).pop, child: const Text('Закрыть')),
                  FilledButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Сохранить'),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Проверьте правильность заполнения формы')));
                        return;
                      }

                      final newODO = int.parse(_odoController.text);
                      context.read<CarsCubit>().updateODO(car.carID, newODO);
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

  void _addMiliage(int miliage) {
    final currentValue = int.tryParse(_odoController.text);
    if (currentValue == null) {
      return;
    }

    _odoController.text = '${currentValue + miliage}';
  }
}
