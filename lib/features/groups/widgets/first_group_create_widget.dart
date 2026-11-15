import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/form_dialog_card.dart';
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
    return FormDialogCard(
      formKey: _formKey,
      icon: Icons.category_rounded,
      title: 'Добавить группу',
      description:
          'Пока нет ни одной группы. Создайте первую — например, «Моторное масло».',
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
        const Divider(height: 1, color: Color(0xFFEDEFF2)),
        FilledButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Добавить группу'),
        ),
      ],
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
