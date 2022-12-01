import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class IContentStore<T> {



  Future<List<T>> getCollectionAsList(ContentQuery? query);

  Query<Map<String, dynamic>> getQueryReference(ContentQuery? query);

  Future<List<T>> queryCollection(ContentQuery query);

  Stream<List<T>> collectionStream(ContentQuery? query);

  Stream<T> contentStream(String id);

  Future<T> getContent(String id);

  Future<T> updateContent(String id, Map<String, dynamic> changes);

  Future<bool> setContent(T data);

  Future<bool> deleteContent(String id);
}
