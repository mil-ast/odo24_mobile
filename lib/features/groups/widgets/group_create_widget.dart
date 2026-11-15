import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
import 'package:odo24_mobile/features/groups/bloc/groups_cubit.dart';
import 'package:odo24_mobile/features/groups/data/models/group_create_request_model.dart';

class GroupCreateWidget extends StatefulWidget {
  const GroupCreateWidget({super.key});

  @override
  State<GroupCreateWidget> createState() => _GroupCreateWidgetState();
}

class _GroupCreateWidgetState extends State<GroupCreateWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GroupsCubit, GroupsState>(
      listener: (context, state) {
        if (state is GroupsCreateSuccessState) {
          Navigator.pop(context);
        }
      },
      child: FormDialogCard(
        formKey: _formKey,
        icon: Icons.category_rounded,
        title: 'Новая группа',
        description:
            'Раздел для однотипных работ: масло, шины, тормоза и другое.',
        children: [
          TextFormField(
            controller: _nameController,
            autofocus: true,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Название группы',
              hintText: 'Например, Моторное масло',
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
            submitLabel: 'Добавить',
            submitIcon: Icons.add_rounded,
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

    final body = GroupCreateRequestModel(name: _nameController.text.trim());
    context.read<GroupsCubit>().create(body);
  }
}
