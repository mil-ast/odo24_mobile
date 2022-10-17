import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/services/dialogs/update/models/service_update_dto.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/services/dialogs/update/service_update_cubit.dart';

class ServiceUpdateWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> serviceDoc;
  final QueryDocumentSnapshot<Object?> groupDoc;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dtController;
  late final TextEditingController _odoController;
  late final TextEditingController _priceController;
  late final TextEditingController _commentController;

  ServiceUpdateWidget(this.groupDoc, this.serviceDoc, {Key? key}) : super(key: key) {
    final Timestamp dtTimestamp = serviceDoc.get('dt');
    final dt = dtTimestamp.toDate();
    final odo = serviceDoc.get('odo');
    final price = serviceDoc.get('price');
    final comment = serviceDoc.get('comment');

    _dtController = TextEditingController.fromValue(TextEditingValue(text: DateFormat('dd.MM.yyyy').format(dt)));
    _odoController = TextEditingController.fromValue(TextEditingValue(text: odo != null ? odo.toString() : ''));
    _priceController = TextEditingController.fromValue(TextEditingValue(text: price != null ? price.toString() : ''));
    _commentController = TextEditingController.fromValue(TextEditingValue(text: comment ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ServiceUpdateCubit(),
      child: BlocConsumer<ServiceUpdateCubit, AppState>(
        listener: (context, state) {
          if (state is AppStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Произошла ошибка'),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          } else if (state is AppStateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Изменения успешно сохранены'),
              ),
            );
            Navigator.pop(context);
          }
        },
        buildWhen: (AppState previous, AppState current) {
          return current is! AppStateError;
        },
        builder: (BuildContext context, AppState state) {
          final now = DateTime.now();
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
                  child: Text('Сохранить изменения'),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Проверьте правильность заполнения формы'),
                        ),
                      );
                    }

                    final dt = DateFormat('dd.MM.yyyy').parse(_dtController.text);
                    final odo = _odoController.text.isNotEmpty ? int.tryParse(_odoController.text) : null;
                    final price = _priceController.text.isNotEmpty ? int.tryParse(_priceController.text) : null;
                    final comment = _commentController.text.trim();

                    final body = ServiceUpdateDTO(
                      dt: Timestamp.fromDate(dt),
                      odo: odo,
                      comment: comment,
                      price: price,
                    );

                    context.read<ServiceUpdateCubit>().update(serviceDoc, body);
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
