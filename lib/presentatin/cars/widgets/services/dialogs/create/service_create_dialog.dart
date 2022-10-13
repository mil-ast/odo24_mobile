import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/services/dialogs/create/service_create_cubit.dart';
import 'package:intl/intl.dart';

class ServiceCreateWidget extends StatelessWidget {
  final QueryDocumentSnapshot<CarModel> carDoc;
  ServiceCreateWidget(this.carDoc, {Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _dtController = TextEditingController();
  final _odoController = TextEditingController();
  final _priceController = TextEditingController();
  final _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceCreateCubit(),
      child: BlocConsumer<ServiceCreateCubit, AppState>(
        listener: (context, state) {
          if (state is AppStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Произошла ошибка'),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          }
        },
        buildWhen: (AppState previous, AppState current) {
          return current is! AppStateError;
        },
        builder: (BuildContext context, AppState state) {
          final now = DateTime.now();
          _dtController.text = DateFormat('dd.MM.yyyy').format(now);
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 10,
                  decoration: InputDecoration(
                    helperText: 'Дата обслуживания',
                    hintText: 'ДД.ММ.ГГГГ',
                    icon: Icon(Icons.calendar_month),
                    suffixIcon: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit_calendar,
                            color: Odo24App.actionsColor,
                          ),
                          onPressed: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: now,
                              firstDate: DateTime(now.year - 3, now.month),
                              lastDate: now,
                            );
                            if (picked != null) {
                              _dtController.text = DateFormat('dd.MM.yyyy').format(picked);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  controller: _dtController,
                  autofocus: false,
                  keyboardType: TextInputType.datetime,
                  validator: (dt) {
                    print(dt);
                    return null;
                  },
                ),
                TextFormField(
                  controller: _odoController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    helperText: 'Пробег авто, км.',
                    icon: Icon(Icons.speed),
                  ),
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
                TextFormField(
                  controller: _priceController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    helperText: 'Стоимость обслуживания',
                    icon: Icon(Icons.money),
                  ),
                  inputFormatters: <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly],
                  validator: (String? input) {
                    if (input != null) {
                      int? odo = int.tryParse(input);
                      if (odo == null) {
                        return 'Некорретное значение пробега';
                      } else if (odo > 9999999) {
                        return 'Слишком большой пробег';
                      }
                    }

                    return null;
                  },
                ),
                TextFormField(
                  controller: _commentController,
                  autofocus: false,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    helperText: 'Комментарий',
                    icon: Icon(Icons.comment),
                  ),
                  validator: (String? input) {
                    if (input != null) {
                      if (input.length > 999) {
                        return 'Слишком длинный комментарий';
                      }
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Сохранить новую запись'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                    }

                    //final odo = int.parse(_odoController.text);
                    //final car = CarModel(_dtController.text, odo, withAvatar: false);

                    //context.read<CarCreateCubit>().create(car);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
