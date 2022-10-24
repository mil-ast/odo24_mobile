import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/create/models/service_create_dto.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/create/service_create_cubit.dart';

class ServiceCreateWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> carDoc;
  final QueryDocumentSnapshot<Object?> groupDoc;
  ServiceCreateWidget(this.carDoc, this.groupDoc, {Key? key}) : super(key: key);

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
          } else if (state is AppStateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Новая запись добавлена'),
                //backgroundColor: Theme.of(context).errorColor,
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
                  child: Text('Добавить'),
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

                    final body = ServiceCreateDTO(
                      carDoc: carDoc.reference,
                      dt: Timestamp.fromDate(dt),
                      odo: odo,
                      comment: comment,
                      price: price,
                    );

                    context.read<ServiceCreateCubit>().create(groupDoc, body);
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
