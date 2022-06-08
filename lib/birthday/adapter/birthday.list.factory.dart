import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/domain/model/imodel.factory.dart';

class BirthdayListFactory extends IModelFactory<BirthdayList> {
  final BirthdayFactory _factory = BirthdayFactory();

  @override
  BirthdayList fromJson(Map<String, dynamic> json) {
    return BirthdayList(
      name: json['name'] as String,
      birthdays: Map.fromIterable(json['birthdays'])
              .map((key, value) => MapEntry(key, _factory.fromJson(value)))
          as Map<String, ABirthday>,
      hex: json['hex'] as int,
      sharedTo: json['sharedTo'] as List<String>,
      canAccessWithLink: json['canAccessWithLink'] as bool,
      id: json['id'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson(BirthdayList model) {
    return {
      'name': model.name,
      'birthdays':
          model.birthdays.values.map((bd) => _factory.toJson(bd)).toList(),
      'hex': model.hex,
      'sharedTo': model.sharedTo,
      'canAccessWithLink': model.canAccessWithLink,
      'id': model.id,
    };
  }
}
