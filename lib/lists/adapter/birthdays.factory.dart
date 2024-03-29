import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';

class BirthdayFactory extends IModelFactory<ABirthday> {
  @override
  fromJson(Map<String, dynamic> json) {
    return ABirthday(
      name: (json['name'] as String).toString().trim(),
      date: DateTime.fromMillisecondsSinceEpoch(json['date']),
      id: json['id'] as String,

    );
  }

  @override
  Map<String, dynamic> toJson(model) => {
        'name': model.name.trim(),
        'date': model.date.millisecondsSinceEpoch,
        'id': model.id,
      };


}
