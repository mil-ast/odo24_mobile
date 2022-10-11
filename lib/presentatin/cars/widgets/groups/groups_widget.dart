import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';
import 'package:odo24_mobile/domain/services/groups_service.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/groups/create/group_create_widget.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/services/services_widget.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class GroupsWidget extends StatelessWidget {
  final QueryDocumentSnapshot<CarModel> carDoc;
  GroupsWidget(this.carDoc, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GroupsService().listener,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<GroupModel>> snap) {
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
                color: Colors.white,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
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
  }

  Widget _buildGroup(BuildContext context, QueryDocumentSnapshot<GroupModel> group) {
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
