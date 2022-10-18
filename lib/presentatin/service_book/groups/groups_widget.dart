import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/create/group_create_widget.dart';
import 'package:odo24_mobile/presentatin/service_book/groups/groups_cubit.dart';
import 'package:odo24_mobile/presentatin/service_book/services/services_widget.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class GroupsWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> carDoc;
  GroupsWidget(this.carDoc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GroupsCubit(),
      child: BlocConsumer<GroupsCubit, AppState>(
          listener: (BuildContext context, AppState state) {},
          builder: (BuildContext context, AppState state) {
            return StreamBuilder(
              stream: context.read<GroupsCubit>().getAll(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Object?>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snap.hasData) {
                  return Text('Нет данных');
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
                              title: Text('Message'),
                              children: [
                                GroupCreateWidget(),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                      ),
                    ),
                    Column(
                      children: snap.data!.docs.map((group) => _buildGroup(context, group)).toList(),
                    ),
                  ],
                );
              },
            );
          }),
    );
  }

  Widget _buildGroup(BuildContext context, QueryDocumentSnapshot<Object?> group) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.folder_open),
            title: Text(group.get('name')),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return ServicesWidget(carDoc, group);
              }));
            },
          ),
        ],
      ),
    );
  }
}
