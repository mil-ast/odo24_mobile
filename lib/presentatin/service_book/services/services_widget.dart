import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:odo24_mobile/core/app_state_core.dart';
import 'package:odo24_mobile/core/utils_core.dart';
import 'package:odo24_mobile/main.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/create/service_create_dialog.dart';
import 'package:odo24_mobile/presentatin/service_book/services/dialogs/update/service_update_dialog.dart';
import 'package:odo24_mobile/presentatin/service_book/services/services_cubit.dart';
import 'package:odo24_mobile/shared_widgets/title_toolbar/title_toolbar_widget.dart';

class ServicesWidget extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> carDoc;
  final QueryDocumentSnapshot<Object?> groupDoc;
  ServicesWidget(this.carDoc, this.groupDoc, {Key? key}) : super(key: key);

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
        child: BlocProvider(
          create: (_) => ServicesCubit(),
          child: Column(
            children: [
              TitleToolBarWidget(
                title: groupDoc.get('name'),
                actionButton: IconButton(
                  color: Odo24App.actionsColor,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => SimpleDialog(
                        contentPadding: EdgeInsets.all(20),
                        insetPadding: EdgeInsets.all(20),
                        title: Text('Добавить сервисное обслуживание'),
                        children: [
                          ServiceCreateWidget(carDoc, groupDoc),
                        ],
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ),
              BlocConsumer<ServicesCubit, AppState>(listener: (context, state) {
                if (state is AppStateServicesActionCreateState) {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      contentPadding: EdgeInsets.all(20),
                      insetPadding: EdgeInsets.all(20),
                      title: Text('Добавить сервисное обслуживание'),
                      children: [
                        ServiceCreateWidget(carDoc, groupDoc),
                      ],
                    ),
                  );
                } else if (state is AppStateServicesActionEditState) {
                  showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      insetPadding: EdgeInsets.all(20),
                      contentPadding: EdgeInsets.all(20),
                      title: Text('Изменить сервисное обслуживание'),
                      children: [
                        ServiceUpdateWidget(groupDoc, state.service),
                      ],
                    ),
                  );
                }
              }, buildWhen: (previous, current) {
                return current is! AppStateDefault;
              }, builder: (context, state) {
                return StreamBuilder(
                    stream: context.read<ServicesCubit>().getServicesByCar(carDoc, groupDoc),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (!snap.hasData) {
                        return Text('Нет данных');
                      }

                      final docs = snap.data!.docs;

                      if (docs.isEmpty) {
                        return Column(
                          children: [
                            SizedBox(height: 40),
                            Icon(Icons.comment),
                            SizedBox(height: 20),
                            Text(
                              'Записей ещё нет :(',
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            Wrap(
                              spacing: 6,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context.read<ServicesCubit>().onClickOpenCreatetDialog();
                                  },
                                  child: Wrap(
                                    children: [
                                      Icon(Icons.add, size: 20, color: Odo24App.actionsColor),
                                      Text(
                                        'Добавить',
                                        style: TextStyle(color: Odo24App.actionsColor, fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  'первую запись',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ],
                        );
                      }

                      return Column(
                        children: docs.map((service) => _buildService(service)).toList(),
                      );
                    });
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildService(QueryDocumentSnapshot<Map<String, dynamic>> service) {
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
                      Text('${service.get('odo') ?? ''}'),
                    ],
                  ),
                ),
                Row(children: [
                  Wrap(
                    direction: Axis.vertical,
                    children: [
                      Text('Дата'),
                      Text(UtilsCore.formatTimestamp(service.get('dt'))),
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
                          context.read<ServicesCubit>().onClickOpenEditDialog(service);
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
                          context.read<ServicesCubit>().delete(service);
                        },
                      )
                    ],
                  ),
                ]),
              ],
            ),
            Text(service.get('comment') ?? ''),
          ],
        ),
      ),
    );
  }
}