import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('AppScaffold отображает заголовок и тело', (tester) async {
    await tester.pumpWidget(wrap(const AppScaffold(title: 'Тест', body: Center(child: Text('Контент')))));

    expect(find.text('Тест'), findsOneWidget);
    expect(find.text('Контент'), findsOneWidget);
  });

  testWidgets('AppCard отображает заголовок и дочерний виджет', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppCard(title: AppCardTitle(title: 'Заголовок'), child: Text('Дочерний'))),
      ),
    );

    expect(find.text('Заголовок'), findsOneWidget);
    expect(find.text('Дочерний'), findsOneWidget);
  });
}