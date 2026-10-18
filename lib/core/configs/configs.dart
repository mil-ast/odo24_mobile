abstract final class Configs {
  static const _hosts = <String>{
    'https://1427507-cd27842.tw1.ru', // основной
    'https://backend.1427507-cd27842.tw1.ru', // резервный
  };

  static const Set<String> baseHosts = _hosts;
  static String get baseHost => _hosts.first;
  static const email = 'odo24@yandex.ru';
  static const gitlabURL = 'https://github.com/mil-ast/odo24_mobile';
  static const sendEmailDuration = Duration(seconds: 30);
}
