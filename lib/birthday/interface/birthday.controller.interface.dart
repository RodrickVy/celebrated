import 'package:bremind/birthday/adapter/birthday.list.factory.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/domain/repository/amen.content/repository/repository.dart';

abstract class BirthdayControllerInterface
    implements ContentRepository<BirthdayBoard, BirthdayBoardFactory> {
  List<BirthdayBoard> get orderedBoards;



  Future<String?> createNewList();
}
