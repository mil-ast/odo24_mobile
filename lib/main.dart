import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/routes.dart' as nav;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Odo24App());
}

class Odo24App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODO24.mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: nav.routes,
    );
  }
}
