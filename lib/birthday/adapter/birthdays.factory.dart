import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/domain/model/imodel.factory.dart';

class BirthdayFactory extends IModelFactory<ABirthday> {
  @override
  fromJson(Map<String, dynamic> json) {
    return ABirthday(
      name: json['name'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      remindMeWhen: DateTime.fromMillisecondsSinceEpoch(json['remindMeWhen']),
      id: json['id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(model) => {
        'name': model.name,
        'date': model.date.millisecondsSinceEpoch,
        'remindMeWhen': model.remindMeWhen.millisecondsSinceEpoch,
        'id': model.id,
      };


}
