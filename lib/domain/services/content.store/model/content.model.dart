import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/domain/services/content.store/model/content.permision.dart';
import 'package:celebrated/domain/services/content.store/model/publication.dart';
import 'content.type.dart';

/// use IFoo for any classes that are abstract or interfaces
abstract class IContent implements IModel{

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


