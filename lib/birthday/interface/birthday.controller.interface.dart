import 'package:celebrated/birthday/adapter/birthday.list.factory.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/domain/repository/amen.content/repository/repository.dart';

abstract class BirthdayControllerInterface
    implements ContentRepository<BirthdayBoard, BirthdayBoardFactory> {
  List<BirthdayBoard> get orderedBoards;



  Future<String?> createNewList();
}
