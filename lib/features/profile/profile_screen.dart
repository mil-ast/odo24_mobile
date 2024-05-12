import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/profile/app_version_information/app_version_information_widget.dart';
import 'package:odo24_mobile/features/profile/change_password/change_password_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = DependenciesScope.of(context).authRepository;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: AppVersionInformationWidget(),
          ),
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
                  onTap: () {
                    authRepository.logout().then((_) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false);
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
