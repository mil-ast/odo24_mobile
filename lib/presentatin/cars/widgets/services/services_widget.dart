import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/domain/models/cars/car_model.dart';
import 'package:odo24_mobile/domain/models/groups/group_model.dart';
import 'package:odo24_mobile/domain/models/services/service_model.dart';
import 'package:odo24_mobile/domain/services/groups_service.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/cars/widgets/services/dialogs/create/service_create_dialog.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class ServicesWidget extends StatelessWidget {
  final QueryDocumentSnapshot<CarModel> carDoc;
  final QueryDocumentSnapshot<GroupModel> group;
  ServicesWidget(this.carDoc, this.group, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(carDoc.get('name')),
            Text(
              'Пробег ${carDoc.get('odo')} км',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TitleToolBarWidget(
              title: group.get('name'),
              actionButton: IconButton(
                color: Odo24App.actionsColor,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      contentPadding: EdgeInsets.all(20),
                      title: Text('Добавить сервисное обслуживание'),
                      children: [
                        ServiceCreateWidget(carDoc),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.add),
              ),
            ),
            StreamBuilder(
                stream: GroupsService().getServicesByCar(carDoc, group),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<ServiceModel>> snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (!snap.hasData) {
                    return Text('Нет данных');
                  }

                  return Column(
                    children:
                        snap.data!.docs.map((QueryDocumentSnapshot<ServiceModel> service) => _buildService(service)).toList(),
                  );
                }),
          ],
        ),
      ),
    );
  }

  Widget _buildService(QueryDocumentSnapshot<ServiceModel> service) {
    final model = service.data();

    return Card(
      elevation: 6,
      shadowColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text('Пробег'),
                      Text(model.odo.toString()),
                    ],
                  ),
                ),
                Row(children: [
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text('Дата'),
                      Text(model.formatDt()),
                    ],
                  ),
                  PopupMenuButton(
                    elevation: 10,
                    shape: OutlineInputBorder(borderSide: BorderSide(color: Colors.black12, width: 1)),
                    icon: Icon(Icons.more_vert),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Wrap(
                          spacing: 10,
                          children: [
                            Icon(Icons.edit),
                            Text('Изменить'),
                          ],
                        ),
                        onTap: () {
                          print(1);
                        },
                      ),
                      PopupMenuItem(
                        child: Wrap(
                          spacing: 10,
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            Text(
                              'Удалить',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        onTap: () {
                          print(1);
                        },
                      )
                    ],
                  ),
                ]),
              ],
            ),
            Text(model.comment ?? ''),
          ],
        ),
      ),
    );
  }

  /*return SingleChildScrollView(
      child: Column(
        children: [
          Text('Services'),
          FutureBuilder(
              future: ServicesService().getAllServicesByCar(carDoc.reference),
              builder: (BuildContext context, AsyncSnapshot<List<QueryDocumentSnapshot<ServiceModel>>> snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snap.hasData) {
                  return Text('Нет данных');
                }

                return Column(
                  children: snap.data!.map((QueryDocumentSnapshot<ServiceModel> service) {
                    final DocumentReference groupRef = service.get('group_ref');
                    groupRef.snapshots().forEach((element) {
                      print(element.get('name'));
                    });
                    return Text(service.get('comment'));
                  }).toList(),
                );
              }),
        ],
      ),
    );*/
}
