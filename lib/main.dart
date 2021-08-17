import 'package:flutter/material.dart';
import 'package:odo24_mobile/routes.dart' as routes;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ODO24 Mobile',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 12, 138, 243), // 0 100 0 40
        accentColor: Color.fromARGB(255, 203, 17, 171),
        textTheme: TextTheme(bodyText2: TextStyle(color: Colors.black87)),
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes.routes,
    );
  }
}
