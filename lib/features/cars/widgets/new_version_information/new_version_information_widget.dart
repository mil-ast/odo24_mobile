import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/features/cars/widgets/new_version_information/bloc/new_version_information_cubit.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';

class NewVersionInformationWidget extends StatefulWidget {
  const NewVersionInformationWidget({super.key});

  @override
  State<StatefulWidget> createState() => _NewVersionInformationState();
}

class _NewVersionInformationState extends State<NewVersionInformationWidget> {
  @override
  Widget build(BuildContext context) {
    final updaterRepository = DependenciesScope.of(context).updaterRepository;
    return BlocProvider(
      create: (context) => NewVersionInformationCubit(
        updaterRepository: updaterRepository,
        checkVersionInterval: const Duration(minutes: 1),
      )..checkVersion(),
      child: BlocBuilder<NewVersionInformationCubit, bool>(
        builder: (context, state) {
          if (state) {
            return const Icon(
              Icons.circle,
              size: 16,
              color: Colors.red,
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
