import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/features/dependencies_scope.dart';
import 'package:odo24_mobile/features/profile/change_password/change_password_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dependencies = DependenciesScope.of(context);
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'Профиль',
      body: SingleChildScrollView(
        child: AppCard(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: const Text('Изменить пароль'),
                leading: const Icon(Icons.password_outlined),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                },
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                title: const Text('О приложении'),
                leading: const Icon(Icons.app_shortcut_rounded),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('О приложении'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset('assets/logo_dark.svg', width: 48, height: 48),

                            const Text('Сервисная книжка автомобиля'),
                            FutureBuilder<PackageInfo>(
                              future: PackageInfo.fromPlatform(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  return Text('Версия: ${snap.data!.version}');
                                } else {
                                  return const Text('...');
                                }
                              },
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Закрыть')),
                        ],
                      );
                    },
                  );
                },
                trailing: const Icon(Icons.chevron_right),
              ),
              ListTile(
                title: Text('Выйти из профиля', style: TextStyle(color: theme.colorScheme.error)),
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  dependencies.authService.logout().ignore();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
