import 'package:flutter/material.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/login/login_screen.dart';
import 'package:odo24_mobile/features/profile/app_version_information/app_version_information_widget.dart';

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
                  title: const Text('Выйти из профиля'),
                  leading: const Icon(Icons.logout),
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
