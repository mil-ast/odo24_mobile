import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_create_request_model.dart';

class GroupCreateWidget extends StatelessWidget {
  GroupCreateWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: BlocListener<GroupsCubit, GroupsState>(
        listener: (context, state) {
          if (state is GroupsCreateSuccessState) {
            Navigator.pop(context);
          }
        },
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(helperText: 'Название группы', icon: Icon(Icons.title)),
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
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: Navigator.of(context).pop, child: const Text('Отмена')),
                    FilledButton(
                      child: const Text('Добавить'),
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
          ),
        ),
      ),
    );
  }
}
