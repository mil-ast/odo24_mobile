import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/error_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/dialogs/fullscreen_dialog.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_cubit.dart';
import 'package:odo24_mobile/features/cars/bloc/cars_states.dart';
import 'package:odo24_mobile/features/cars/car_item_widget.dart';
import 'package:odo24_mobile/features/cars/widgets/create/car_create_dialog.dart';
import 'package:odo24_mobile/features/cars/widgets/create/car_create_form_widget.dart';
import 'package:odo24_mobile/features/cars/widgets/edit/car_edit_form_dialog.dart';
import 'package:odo24_mobile/features/cars/widgets/edit_miliage/edit_miliage_widget.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/groups/groups_screen.dart';

/* class CarsDependenciesScope extends InheritedWidget {
  final CarModel selectedCar;

  const CarsDependenciesScope({super.key, required this.selectedCar, required super.child});

  static CarsDependenciesScope of(BuildContext context) {
    final model = context.dependOnInheritedWidgetOfExactType<CarsDependenciesScope>();

    assert(model?.selectedCar != null, 'No DependenciesScope found in context');
    return model!;
  }

  @override
  bool updateShouldNotify(covariant CarsDependenciesScope oldWidget) => selectedCar != oldWidget.selectedCar;
} */

class CarsScreenScope extends StatelessWidget {
  final Widget child;
  const CarsScreenScope({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final carsRepository = DependenciesScope.of(context).carsRepository;
    return BlocProvider(
      create: (context) => CarsCubit(carsRepository: carsRepository),
      child: child,
    );
  }
}

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  static Future<void> open(BuildContext context) =>
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CarsScreen.create()));

  static Widget create() => const CarsScreenScope(child: CarsScreen());

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CarsCubit>().getAllCars();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Сервисная книжка авто',
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<CarsCubit>().openFormCreateCar,
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<CarsCubit, CarsState>(
        listenWhen: (previous, current) => !current.needBuild,
        listener: (BuildContext context, CarsState state) async {
          switch (state) {
            case CarsErrorState():
              showErrorDialog(context, title: 'Ошибка', message: state.message);
            case CarActionSelectState():
              await GroupsScreen.open(context, selectedCar: state.car);
              if (context.mounted) {
                context.read<CarsCubit>().getAllCars();
              }
            case CarActionShowCreateDialogState():
              showFullScreenDialog(
                context,
                title: 'Добавить новый авто',
                body: BlocProvider.value(value: context.read<CarsCubit>(), child: const CarCreateDialog()),
              );
            case CarActionShowUpdateDialogState():
              showFullScreenDialog(
                context,
                title: 'Изменить авто',
                body: BlocProvider.value(
                  value: context.read<CarsCubit>(),
                  child: CarEditDialog(car: state.car),
                ),
              );
            case CarActionShowUpdateMiliageDialogState():
              showFullScreenDialog(
                context,
                title: 'Изменить пробег',
                body: BlocProvider.value(value: context.read<CarsCubit>(), child: EditMiliageWidget(state.car)),
              );
            case CarActionShowDeleteDialogState():
              final isOk = await showConfirmationDialog(
                context,
                title: 'Удаление авто',
                message: 'Вы действительно хотите удалить авто "${state.car.name}" и все записи из неё?',
              );
              if ((isOk ?? false) && context.mounted) {
                context.read<CarsCubit>().delete(state.car);
              }
            case CarCreateSuccessState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Новый авто успешно добавлен!')));
            case CarUpdateSuccessState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Изменения успешно сохранены!')));
            case CarDeleteSuccessState():
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Авто успешно удалён')));
            default:
          }
        },
        buildWhen: (previous, current) => current.needBuild,
        builder: (context, state) {
          if (state is CarsWaitingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CarsLoadedState && state.cars.isNotEmpty) {
            return ListView.separated(
              separatorBuilder: (context, i) => const SizedBox(height: 20),
              itemCount: state.cars.length,
              itemBuilder: (context, i) => CarItemWidget(car: state.cars[i]),
            );
          }

          return const SingleChildScrollView(
            child: Column(
              children: [
                AppCard(
                  title: AppCardTitle(title: 'Добавить авто'),
                  child: CarCreateFormWidget(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
