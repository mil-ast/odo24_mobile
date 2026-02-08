import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/services_old/bloc/services_cubit.dart';

class EmptyServicesWidget extends StatelessWidget {
  const EmptyServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Column(
            children: [
              const Text('Записей ещё нет'),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: context.read<ServicesCubit>().openFormCreateService,
                icon: const Icon(Icons.add),
                label: const Text('Добавить первую запись'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
