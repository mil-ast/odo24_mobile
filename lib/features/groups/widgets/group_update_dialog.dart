import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_model.dart';
import 'package:odo24_mobile/features/groups/data/models/group_update_request_model.dart';

class GroupUpdateWidget extends StatefulWidget {
  final GroupModel group;

  const GroupUpdateWidget(this.group, {super.key});

  @override
  State<GroupUpdateWidget> createState() => _GroupUpdateWidgetState();
}

class _GroupUpdateWidgetState extends State<GroupUpdateWidget> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.group.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsCubit, GroupsState>(
      listener: (context, state) {
        if (state is GroupsUpdateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: FormDialogCard(
        formKey: _formKey,
        icon: Icons.category_rounded,
        title: 'Изменить группу',
        description: 'Новое название появится в списке групп.',
        children: [
          TextFormField(
            controller: _nameController,
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Название группы',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            validator: (String? name) {
              final length = name?.trim().length ?? 0;
              if (length < 3) {
                return 'Название слишком короткое';
              } else if (length > 120) {
                return 'Название слишком длинное';
              }
              return null;
            },
            onFieldSubmitted: (_) => _submit(),
          ),
          FormDialogActions(
            submitLabel: 'Сохранить',
            submitIcon: Icons.save_outlined,
            onCancel: Navigator.of(context).pop,
            onSubmit: _submit,
          ),
        ],
      ),
    );
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Проверьте правильность заполнения формы'),
        ),
      );
      return;
    }

    final body = GroupUpdateRequestModel(
      groupID: widget.group.groupID,
      name: _nameController.text.trim(),
    );
    context.read<GroupsCubit>().update(body);
  }
}
