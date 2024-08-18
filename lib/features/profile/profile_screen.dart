import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/profile/app_version_information/app_version_information_widget.dart';
import 'package:odo24_mobile/features/profile/change_password/change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
            child: AppVersionInformationWidget(),
          ),
          const Divider(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Изменить пароль'),
                  leading: const Icon(Icons.password_outlined),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  title: const Text(
                    'Выйти из профиля',
                    style: TextStyle(color: Colors.red),
                  ),
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    dependencies.authRepository.logout().ignore();

                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                        (route) => false);
                  },
                ),
              ],
            ),
          ),
          if (!kIsWeb)
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Wrap(
                spacing: 8,
                children: [
                  Icon(Icons.launch_outlined, color: theme.colorScheme.primary),
                  InkWell(
                    onTap: () {
                      dependencies.methodChannel.invokeMethod<List<dynamic>>('launchURL', <String, String>{
                        'url': dependencies.siteURL,
                      });
                    },
                    child: Text(
                      dependencies.siteURL,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
