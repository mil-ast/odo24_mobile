import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/groups/bloc/groups_states.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_create_request_model.dart';

class GroupCreateWidget extends StatelessWidget {
  GroupCreateWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Добавление новой группы'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocListener<GroupsCubit, GroupsState>(
          listener: (context, state) {
            if (state is GroupsCreateSuccessState) {
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
                            context.read<GroupsCubit>().showMessage('Проверьте правильность заполнения формы');
                            return;
                          }

                          final body = GroupCreateRequestModel(
                            name: _nameController.text.trim(),
                          );
                          context.read<GroupsCubit>().create(body);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
