import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_create_request_model.dart';

class FirstGroupCreateWidget extends StatefulWidget {
  const FirstGroupCreateWidget({super.key});

  @override
  State<FirstGroupCreateWidget> createState() => _FirstGroupCreateWidgetState();
}

class _FirstGroupCreateWidgetState extends State<FirstGroupCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController.fromValue(
    const TextEditingValue(text: 'Моторное масло'),
  );

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Icon(Icons.comment),
            const SizedBox(height: 20),
            Text('Групп ещё нет :(', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 20),
            Column(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(helperText: 'Название группы'),
                  validator: (String? name) {
                    final length = name?.trim().length ?? 0;
                    if (length < 3) {
                      return 'Название слишком короткое';
                    } else if (length > 120) {
                      return 'Название слишком длинное';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FilledButton(
                      child: const Text('Добавить группу'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('Проверьте правильность заполнения формы')));
                          return;
                        }

                        final body = GroupCreateRequestModel(name: _nameController.text.trim());
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
    );
  }
}
