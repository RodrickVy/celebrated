import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:get/get.dart';

mixin BoardsViewController   {
  final RxString currentListId  = ''.obs;

  RxMap<String,BirthdayBoard> get birthdayBoards;
  ///A transformer => List of boards extracted form controllers birthdayBoards but ordered by the one last interacted with.
   List<BirthdayBoard> get orderedBoards {

     // final String? idInRoute = Get.parameters["listId"];
     if (birthdayBoards.isNotEmpty && currentListId.isNotEmpty){
       return [
         ...birthdayBoards.values.where((element) {
           return element.id == currentListId.value;
         }).toList(),
         ...birthdayBoards.values.where((element) {
           return element.id != currentListId.value;
         }).toList()
       ];
     }else{
       return birthdayBoards.values.toList();
     }
   }




  /// orders the lists to have the List with the provided id as first
}
