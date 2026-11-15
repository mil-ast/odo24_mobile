import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odo24_mobile/core/configs/configs.dart';
import 'package:odo24_mobile/core/shared_widgets/scaffold/app_scaffold.dart';
import 'package:odo24_mobile/core/theme/color_scheme.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppScaffold(
      title: 'О приложении',
      body: Material(
        color: ODO24LightThemeColors.surfaceMuted,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              const _HeroCard(),
              const _SectionTitle('О проекте'),
              const _FeaturesCard(),
              const _SectionTitle('Ссылки и контакты'),
              _ContactsCard(
                onOpenSite: () => _openSite(context),
                onSendEmail: () => _sendEmail(context),
                onOpenSource: () => _openGitlab(context),
              ),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snap) {
                  final version = snap.hasData
                      ? 'Версия ${snap.data!.version}'
                      : 'Версия …';
                  return Column(
                    spacing: 8,
                    children: [
                      Text(
                        'Самая актуальная версия — на сайте',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.black45,
                        ),
                      ),
                      Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            version,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _sendEmail(BuildContext context) async {
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: AppConfig.email,
      queryParameters: {
        'subject': 'Сервисная книжка автомобиля',
        'body': 'Текст сообщения',
      },
    );

    await _launchExternal(
      context,
      emailLaunchUri,
      'Не удалось открыть почтовый клиент',
    );
  }

  Future<void> _openGitlab(BuildContext context) async {
    final url = Uri.parse(AppConfig.gitlabURL);
    await _launchExternal(
      context,
      url,
      'Не удалось открыть ссылку',
      external: true,
    );
  }

  Future<void> _openSite(BuildContext context) async {
    final url = Uri.parse(AppConfig.siteURL);
    await _launchExternal(
      context,
      url,
      'Не удалось открыть ссылку',
      external: true,
    );
  }

  Future<void> _launchExternal(
    BuildContext context,
    Uri uri,
    String errorMessage, {
    bool external = false,
  }) async {
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      if (!await canLaunchUrl(uri)) {
        messenger?.showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }
      final launched = await launchUrl(
        uri,
        mode: external
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
      if (!launched) {
        messenger?.showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } catch (e) {
      messenger?.showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _AboutCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            SvgPicture.asset('assets/logo_v2.svg', width: 72, height: 72),
            const SizedBox(height: 16),
            Text(
              'Сервисная книжка автомобиля',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Обслуживание, пробег и расходы — всё в одном месте.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _FeaturesCard extends StatelessWidget {
  const _FeaturesCard();

  @override
  Widget build(BuildContext context) {
    return const _AboutCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 18,
          children: [
            _FeatureRow(
              icon: Icons.money_off_outlined,
              color: Color(0xFF2E7D32),
              title: 'Бесплатно и без рекламы',
              description:
                  'Приложение не является коммерческим, в нём нет платных функций, подписок и рекламы.',
            ),
            _FeatureRow(
              icon: Icons.monitor_heart_outlined,
              color: Color(0xFF1565C0),
              title: 'Поддерживаем своими силами',
              description:
                  'Поддержка и развитие приложения осуществляется своими силами.\nМы сами оплачиваем аренду серверов и поддержку инфраструктуры, чтобы сервис оставался доступным для всех.',
            ),
            _FeatureRow(
              icon: Icons.free_breakfast_outlined,
              color: Color(0xFFC2185B),
              title: 'Делаем на энтузиазме',
              description:
                  'Мы создаем этот продукт на энтузиазме, чтобы упростить жизнь владельцам авто.\nПросим вас отнестись с пониманием, если на пути встретятся какие-то недоработки или ошибки.',
            ),
            _FeatureRow(
              icon: Icons.healing_outlined,
              color: Color(0xFFEF6C00),
              title: 'Помогите стать лучше',
              description:
                  'Вы можете помочь нам стать лучше и сообщить об ошибках или предложить новые идеи.',
            ),
            _FeatureRow(
              icon: Icons.code_outlined,
              color: Color(0xFF6D4C41),
              title: 'Открытый исходный код',
              description:
                  'Весь исходный код открыт и любой желающий может внести свой вклад в развитие. Вся информация ниже.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactsCard extends StatelessWidget {
  final VoidCallback onOpenSite;
  final VoidCallback onSendEmail;
  final VoidCallback onOpenSource;

  const _ContactsCard({
    required this.onOpenSite,
    required this.onSendEmail,
    required this.onOpenSource,
  });

  @override
  Widget build(BuildContext context) {
    return _AboutCard(
      child: Column(
        children: [
          _ContactTile(
            icon: Icons.language_rounded,
            title: 'Сайт',
            subtitle: AppConfig.siteURL,
            onTap: onOpenSite,
          ),
          const _ContactDivider(),
          _ContactTile(
            icon: Icons.mail_outline_rounded,
            title: 'Написать нам',
            subtitle: AppConfig.email,
            onTap: onSendEmail,
          ),
          const _ContactDivider(),
          _ContactTile(
            icon: Icons.code_rounded,
            title: 'Исходный код',
            subtitle: AppConfig.gitlabURL.replaceFirst(
              RegExp(r'^https?://'),
              '',
            ),
            onTap: onOpenSource,
          ),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 6, 12, 6),
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 20, color: Colors.black45),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.black45),
      ),
      trailing: const Icon(
        Icons.open_in_new_rounded,
        size: 18,
        color: Colors.black26,
      ),
    );
  }
}

class _ContactDivider extends StatelessWidget {
  const _ContactDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 66,
      endIndent: 16,
      color: Color(0xFFEDEFF2),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final Widget child;

  const _AboutCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        clipBehavior: Clip.antiAlias,
        child: child,
      ),
    );
  }
}
