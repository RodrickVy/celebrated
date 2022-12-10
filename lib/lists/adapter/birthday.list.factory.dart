// ignore_for_file: prefer_for_elements_to_map_from iterable

import 'package:celebrated/lists/adapter/birthdays.factory.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/lists/model/watcher.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';
import 'package:get/get.dart';

class BirthdayBoardFactory extends IModelFactory<BirthdayBoard> {
  final BirthdayFactory _factory = BirthdayFactory();

  @override
  BirthdayBoard fromJson(Map<String, dynamic> json) {
    try{
      return BirthdayBoard(
          name: (json['name'] as String).toString().trim(),
          birthdays: {
            if(json['birthdays'] != null)for (var val in json['birthdays']) val["id"]: _factory.fromJson(val)
          },
          hex: (json['hex'] as int) == 0 ? 0xFFFF6633 : (json['hex'] as int),
          sharedTo: List.from(json['sharedTo']),
          viewingId: json["viewingId"] ?? json['viewLink'] ?? '',
          id: json['id'] as String,
          addingId:json["addingId"] ?? json["birthdayAddLink"] ?? '',
          authorId: json['authorId'] ?? '',
          startReminding: json['startReminding']??2,
          notificationType: BirthdayReminderType.values.byName(json['notificationType']??'sms'),
          authorName: (json["authorName"]??'').toString().trim(),
          watchers: List.from(json['watchers']??[])
      );
    }catch(_){
      Get.log("Error in serializing BirthdayBoard from json");
      return BirthdayBoard.empty();
    }

  }

  @override
  Map<String, dynamic> toJson(BirthdayBoard model) {
    return {
      'name': model.name,
      'birthdays': model.birthdays.values
          .map((ABirthday bd) => _factory.toJson(bd))
          .toList(),
      'hex': model.hex,
      'sharedTo': model.sharedTo,
      'viewingId': model.viewingId,
      "addingId": model.addingId,
      'id': model.id,
      'notificationType':model.notificationType.name,
      'authorId': model.authorId,
      'startReminding': model.startReminding,
      'authorName':model.authorName,
      'watchers':model.watchers
    };
  }
}
