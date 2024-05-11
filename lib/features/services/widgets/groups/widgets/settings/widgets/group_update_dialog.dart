import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/services/widgets/groups/bloc/groups_states.dart';
import 'package:odo24_mobile/features/services/widgets/groups/data/models/group_model.dart';

class GroupUpdateWidget extends StatelessWidget {
  final GroupModel group;
  GroupUpdateWidget(this.group, {super.key});

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController.fromValue(TextEditingValue(text: group.name));

    return Padding(
      padding: const EdgeInsets.all(20),
      child: BlocListener<GroupsCubit, GroupsState>(
        listener: (context, state) {
          if (state is GroupsUpdateSuccessState) {
            Navigator.pop(context);
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
                      child: const Text('Закрыть'),
                    ),
                    FilledButton(
                      child: const Text('Сохранить'),
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Проверьте правильность заполнения формы'),
                            ),
                          );
                          return;
                        }

                        final newGroup = GroupModel(
                          groupID: group.groupID,
                          name: _nameController.text.trim(),
                          sort: group.sort,
                        );
                        context.read<GroupsCubit>().update(newGroup);
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
