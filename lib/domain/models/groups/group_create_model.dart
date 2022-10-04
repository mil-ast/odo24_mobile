import 'package:odo24_mobile/core/model_core.dart';

class GroupCreateModel implements ModelCore {
  final String name;
  final String uid;

  GroupCreateModel({
    required this.name,
    required this.uid,
  });

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'uid': uid,
      };
}
