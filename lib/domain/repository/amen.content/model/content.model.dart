import 'package:bremind/domain/model/imodel.dart';
import 'package:bremind/domain/repository/amen.content/model/content.permision.dart';
import 'package:bremind/domain/repository/amen.content/model/publication.dart';
import 'content.type.dart';

abstract class AfroContent implements IModel{

   List<String> get tags;
   int get likes;
   int get shares;
   int get notesTaken;
   int get highlightsMade;
   int get downloads;
   int get seenBy;
   List<String> get reports;
   DateTime get releaseDate;
   String get language;
   @override
  String get id;
   String get downloadUrl;
   String get description;
   ContentType get type;
   String get name;
   String get author;
   ContentPermissions get permissions;
   PublicationState get publication;



}


