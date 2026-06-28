import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/shared_widgets/app_card/app_card.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomTextStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white);

    return AppScaffold(
      title: 'О приложении',
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              spacing: 10,
              children: [
                SvgPicture.asset('assets/logo_v2.svg', width: 64, height: 64),
                const SizedBox(height: 20),
                const AppCard(
                  title: AppCardTitle(title: 'Сервисная книжка автомобиля'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10,
                    children: [
                      Icon(Icons.money_off_outlined, color: Colors.green),
                      Text('Приложение не является коммерческим, в нём нет платных функций, подписок и рекламы.'),
                      Icon(Icons.monitor_heart_outlined, color: Colors.blue),
                      Text(
                        'Поддержка и развитие приложения осуществляется своими силами.\nМы сами оплачиваем аренду серверов и поддержку инфраструктуры, чтобы сервис оставался доступным для всех.',
                      ),
                      Icon(Icons.free_breakfast_outlined, color: Colors.pink),
                      Text(
                        'Мы создаем этот продукт на энтузиазме, чтобы упростить жизнь владельцам авто.\rПросим вас отнестись с пониманием, если на пути встретятся какие-то недоработки или ошибки.',
                      ),
                      Icon(Icons.healing_outlined, color: Colors.orange),
                      Text('Вы можете помочь нам стать лучше и сообщить об ошибках или предложить новые идеи.'),
                      Icon(Icons.code_outlined, color: Colors.brown),
                      Text(
                        'Весь исходный код открыт и любой желающий может внести свой вклад в развитие. Вся информация ниже.',
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Wrap(
                  spacing: 20,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _sendEmail,
                      icon: const Icon(Icons.email_outlined),
                      label: const Text('Написать нам'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _openGitlab,
                      icon: const Icon(Icons.link_outlined),
                      label: const Text('Gitlab'),
                    ),
                  ],
                ),

                Text('E-mail: ${Configs.email}', style: bottomTextStyle),

                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Text('Версия: ${snap.data!.version}', style: bottomTextStyle);
                    } else {
                      return Text('...', style: bottomTextStyle);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail() async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: Configs.email,
      queryParameters: {'subject': 'Сервисная книжка автомобиля', 'body': 'Текст сообщения'},
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Не удалось открыть почтовый клиент';
    }
  }

  Future<void> _openGitlab() async {
    final url = Uri.parse(Configs.gitlabURL);

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Не удалось открыть ссылку');
    }
  }
}
