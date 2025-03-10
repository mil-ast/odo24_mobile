import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:odo24_mobile/core/theme/theme_preferences.dart';
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
      body: ListView(
        children: [
          const AppVersionInformationWidget(),
          SwitchThemeWidget(
            themePreferences: dependencies.themePreferences,
          ),
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
            trailing: const Icon(Icons.chevron_right),
          ),
          if (!kIsWeb)
            ListTile(
              title: const Text('Перейти на сайт'),
              onTap: () {
                dependencies.methodChannel.invokeMethod<List<dynamic>>('launchURL', <String, String>{
                  'url': dependencies.siteURL,
                });
              },
              subtitle: Text(
                dependencies.siteURL,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          ListTile(
            title: Text(
              'Выйти из профиля',
              style: TextStyle(color: theme.colorScheme.error),
            ),
            leading: Icon(
              Icons.logout,
              color: theme.colorScheme.error,
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
    );
  }
}

class SwitchThemeWidget extends StatelessWidget {
  final ThemePreferences themePreferences;

  const SwitchThemeWidget({
    required this.themePreferences,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: themePreferences.brightness,
      builder: (context, value, _) {
        return ListTile(
          title: const Text('Тёмная тема'),
          onTap: () {
            themePreferences.setTheme(value == Brightness.dark ? Brightness.light : Brightness.dark);
          },
          trailing: Switch(
            value: value == Brightness.dark,
            activeColor: Colors.black,
            onChanged: (bool isDark) {
              themePreferences.setTheme(isDark ? Brightness.dark : Brightness.light);
            },
          ),
        );
      },
    );
  }
}
