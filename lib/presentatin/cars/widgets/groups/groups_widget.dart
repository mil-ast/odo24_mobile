import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';
import 'package:odo24_mobile/domain/services/groups_service.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/groups/create/group_create_widget.dart';

class GroupsWidget extends StatelessWidget {
  GroupsWidget({Key? key}) : super(key: key);

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
            Container(
              color: Odo24App.secondColor,
              child: Padding(
                padding: EdgeInsets.only(top: 10, right: 0, bottom: 10, left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: const Text(
                        'Группы',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
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
                    )
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: snap.data!.docs.map((QueryDocumentSnapshot<GroupModel> car) => _buildGroup(context, car)).toList(),
              ),
            ),
          ],
        );

        //
      },
    );
  }

  Widget _buildGroup(BuildContext context, QueryDocumentSnapshot<GroupModel> group) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.folder_copy_outlined),
            title: Text(group.get('name')),
            onTap: () {
              final services = group.reference.collection('services').get();
              services.then((v) {
                var d = v.docs;
                var data = d.first.data();
                print(v.size);
              });
              print(group);
              /*Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CarItemScreen(car),
                ),
              );*/
            },
          ),
        ],
      ),
    );
  }
}
