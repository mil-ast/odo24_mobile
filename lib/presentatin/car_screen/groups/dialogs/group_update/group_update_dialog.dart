import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/presentatin/car_screen/groups/dialogs/group_update/group_update_cubit.dart';
import 'package:odo24_mobile/repository/groups/group_update_request_model.dart';
import 'package:odo24_mobile/services/groups/models/group.model.dart';

class GroupUpdateWidget extends StatelessWidget {
  final GroupModel group;
  GroupUpdateWidget(this.group, {super.key});

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    _nameController = TextEditingController.fromValue(TextEditingValue(text: group.name));

    return BlocProvider(
      create: (_) => GroupUpdateCubit(),
      child: BlocListener<GroupUpdateCubit, AppState>(
        listener: (context, state) {
          if (state is AppStateSuccess<GroupUpdateRequestModel>) {
            group.name = state.data!.name;
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
                    ElevatedButton(
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

                        final body = GroupUpdateRequestModel(
                          groupID: group.groupID,
                          name: _nameController.text.trim(),
                        );
                        context.read<GroupUpdateCubit>().update(body);
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
