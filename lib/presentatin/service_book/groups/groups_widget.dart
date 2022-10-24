import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/create/group_create_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/groups_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/sort_groups_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/update/group_update_widget.dart';
import 'package:odo24_mobile/shared_widgets/dialogs/confirmation_dialog.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class GroupsWidget extends StatelessWidget {
  final QueryDocumentSnapshot carDoc;
  GroupsWidget(this.carDoc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit(),
      child: BlocConsumer<GroupsCubit, AppState>(listener: (BuildContext context, AppState state) {
        if (state is OnUpdateGroupState) {
          showDialog(
            context: context,
            builder: (context) => SimpleDialog(
              insetPadding: EdgeInsets.all(20),
              contentPadding: EdgeInsets.all(20),
              title: Text('Редактировать авто'),
              children: [
                GroupUpdateWidget(state.group),
              ],
            ),
          );
        } else if (state is OnDeleteGroupState) {
          showConfirmationDialog(
            context,
            title: state.group.get('name'),
            message: 'Вы действительно хотите удалить группу и все записи в ней?',
            btnNoText: 'Отмена',
            btnOkText: 'Удалить',
          ).then((bool? isOk) {
            if (isOk == true) {
              context.read<GroupsCubit>().delete(state.group);
            }
          });
        }
      }, buildWhen: (previous, current) {
        return current is AppStateDefault;
      }, builder: (BuildContext context, AppState state) {
        return StreamBuilder(
          stream: context.read<GroupsCubit>().getAll(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (!snap.hasData) {
              return Text('Нет данных');
            }

            final docs = snap.data!.docs;
            if (docs.isEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      'Добавьте первую группу',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text('Записи о сервисном обслуживании разбиваются по вашим группам'),
                    SizedBox(height: 20),
                    GroupCreateWidget(
                      isEmbedded: true,
                      suggestion: 'Моторное масло',
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleToolBarWidget(
                  title: 'Группы',
                  actionButton: IconButton(
                    color: Odo24App.actionsColor,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SimpleDialog(
                          insetPadding: EdgeInsets.all(20),
                          contentPadding: EdgeInsets.all(20),
                          title: Text('Добавить новую группу'),
                          children: [
                            GroupCreateWidget(),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                  ),
                ),
                Expanded(
                  child: SortGroupsWidget(docs, carDoc),
                ),
                /*Column(
                  children: docs.map((group) => _buildGroup(context, group)).toList(),
                ),*/
              ],
            );
          },
        );
      }),
    );
  }
}
