import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/data/repository/groups/models/group_create_request_model.dart';

class GroupCreateWidget extends StatelessWidget {
  final GroupsCubit groupsCubit;
  GroupCreateWidget(this.groupsCubit, {super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsCubit, AppState>(
      bloc: groupsCubit,
      listener: (context, state) {
        if (state is GroupCreateSuccessful) {
          Navigator.pop(context, state.newGroup);
        }
      },
      child: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  helperText: 'Название группы',
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Отмена'),
                  ),
                  ElevatedButton(
                    child: const Text('Добавить'),
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Проверьте правильность заполнения формы'),
                          ),
                        );
                        return;
                      }

                      final body = GroupCreateRequestModel(
                        name: _nameController.text.trim(),
                      );
                      groupsCubit.create(body);
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
}
