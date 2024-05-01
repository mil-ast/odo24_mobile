import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/groups/data/models/group_create_request_model.dart';

class FirstGroupCreateWidget extends StatelessWidget {
  FirstGroupCreateWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController.fromValue(
    const TextEditingValue(text: 'Моторное масло'),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.comment),
              const SizedBox(height: 20),
              Text(
                'Групп ещё нет :(',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      helperText: 'Название группы',
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Добавить группу'),
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
            ],
          ),
        ),
      ),
    );
  }
}
