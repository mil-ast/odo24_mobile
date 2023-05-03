import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups_cubit.dart';
import 'package:odo24_mobile/repository/groups/models/group_create_request_model.dart';

class FormGroupCreateWidget extends StatelessWidget {
  FormGroupCreateWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController.fromValue(
    const TextEditingValue(text: 'Моторное масло'),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.comment),
          const SizedBox(height: 20),
          const Text(
            'Групп ещё нет :(',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20),
          Builder(
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
                          context.read<GroupsCubit>().create(body);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
