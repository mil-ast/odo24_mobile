import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/services_core.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/create/group_create_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/create/models/group_create_dto.dart';

class GroupCreateWidget extends StatelessWidget {
  final bool isEmbedded;
  final String? suggestion;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  GroupCreateWidget({this.isEmbedded = false, this.suggestion, Key? key}) : super(key: key) {
    if (suggestion != null) {
      _nameController.text = suggestion!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GroupCreateCubit(),
      child: BlocConsumer<GroupCreateCubit, AppState>(
        listener: (context, state) {
          if (state is AppStateSuccess) {
            if (!isEmbedded) {
              Navigator.of(context).pop();
            }
          } else if (state is AppStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Произошла ошибка'),
                backgroundColor: Theme.of(context).errorColor,
              ),
            );
          }
        },
        buildWhen: (AppState previous, AppState current) {
          return current is AppStateDefault || current is AppStateLoading;
        },
        builder: (BuildContext context, AppState state) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    helperText: 'Название новой группы',
                    icon: Icon(Icons.title),
                  ),
                  validator: (String? name) {
                    if (name == null || name.length < 3) {
                      return 'Название слишком короткое';
                    } else if (name.length > 120) {
                      return 'Название слишком длинное';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (!isEmbedded)
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Закрыть'),
                      )
                    else
                      SizedBox.shrink(),
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

                        final body = GroupCreateDTO(
                          uid: ProficeServicesCore.userID,
                          name: _nameController.text.trim(),
                        );

                        context.read<GroupCreateCubit>().create(body);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
