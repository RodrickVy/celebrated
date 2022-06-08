import 'package:bremind/domain/model/imodel.dart';
import 'package:bremind/domain/model/imodel.factory.dart';
import 'package:bremind/domain/repository/amen.content/interface/content.repository.interface.dart';
import 'package:bremind/domain/repository/amen.content/model/query.dart';
import 'package:bremind/domain/repository/amen.content/model/query.methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class ContentRepository<T extends IModel, F extends IModelFactory<T>>
    implements IContentRepositoryInterface<T> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final Map<String, List<T>> _cashed = {};

  late T empty;

  late F docFactory;

  late String dbCollectionPath;

  late CollectionReference<Map<String, dynamic>> collectionReference;

  // ContentRepository(
  //     {required this.empty,
  //     required this.docFactory,
  //     required this.dbCollectionPath}) {
  //   collectionReference = firestore.collection(dbCollectionPath);
  // }

  Future<List<T>> getCollectionAsList(ContentQuery? query) async {
    return (await getQueryReference(query).get())
        .docs
        .map((QueryDocumentSnapshot doc) {
      if (doc.data() != null) {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      }
    }).toList();
  }

  Future<List<T>> filter(List<T> docs,ContentQuery? query) async {
    List<T> _data = await (await getQueryReference(query).where("id",whereIn: docs.map((e) => e.id).toList()).get())
        .docs
        .map((QueryDocumentSnapshot doc) {
      if (doc.data() != null) {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      }
    }).toList();

    return _data;
  }

  Query<Map<String, dynamic>> getQueryReference(ContentQuery? query) {
    if (query != null) {
      return whereQueryRef(query)
          .limit(query.limit)
          .orderBy(query.orderProperty, descending: query.orderDescending);
    } else {
      return collectionReference;
    }
  }

  Query<Map<String, dynamic>> whereQueryRef(ContentQuery? query) {
    if (query != null) {
      switch (query.method) {
        case QueryMethods.isEqualTo:
          return collectionReference.where(query.property,
              isEqualTo: query.value);
        case QueryMethods.isNotEqualTo:
          return collectionReference.where(query.property,
              isNotEqualTo: query.value);
        case QueryMethods.isLessThan:
          return collectionReference.where(query.property,
              isLessThan: query.value);
        case QueryMethods.isLessThanOrEqualTo:
          return collectionReference.where(query.property,
              isLessThanOrEqualTo: query.value);
        case QueryMethods.isGreaterThan:
          return collectionReference.where(query.property,
              isGreaterThan: query.value);
        case QueryMethods.isGreaterThanOrEqualTo:
          return collectionReference.where(query.property,
              isGreaterThanOrEqualTo: query.value);

        case QueryMethods.arrayContains:
          return collectionReference.where(query.property,
              arrayContains: query.value);

        case QueryMethods.arrayContainsAny:
          return collectionReference.where(query.property,
              arrayContainsAny: query.value as List);
        case QueryMethods.whereIn:
          return collectionReference.where(query.property,
              whereIn: query.value as List);
        case QueryMethods.whereNotIn:
          return collectionReference.where(query.property,
              whereNotIn: query.value as List);
        case QueryMethods.isNull:
          return collectionReference.where(query.property, isNull: true);
      }
    } else {
      return collectionReference;
    }
  }


  
  Future<List<T>> queryCollection(ContentQuery query) async {
    if (!_cashed.containsKey(query.id)) {
      List<T> _data = (await getQueryReference(query).get())
          .docs
          .map((QueryDocumentSnapshot doc) {
        if (doc.data() != null) {
          return docFactory.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return docFactory.fromJson(doc.data() as Map<String, dynamic>);
        }
      }).toList();
      _cashed.assign(query.id, _data);
      return _data;
    } else {
      return _cashed[query.id]!;
    }
  }

  Stream<List<T>> collectionStream(ContentQuery? query) {
    return getQueryReference(query).snapshots().map((QuerySnapshot event) {
      return event.docChanges.map((e) {
        if (e.doc.data() != null) {
          return docFactory.fromJson(e.doc.data() as Map<String, dynamic>);
        } else {
          return docFactory.fromJson(e.doc.data() as Map<String, dynamic>);
        }
      }).toList();
    });
  }

  Stream<T> contentStream(String id) {
    return collectionReference
        .doc(id)
        .snapshots()
        .map((DocumentSnapshot event) {
      return docFactory.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  Future<T> getContent(String id) async {
    DocumentSnapshot _snapshot = await collectionReference.doc(id).get();

    if (_snapshot.exists && _snapshot.data() != null) {
      return docFactory.fromJson(_snapshot.data() as Map<String, dynamic>);
    } else {
      throw "Document Not Found";
    }
  }

  Future<T> updateContent(String id, Map<String, dynamic> changes) async {
    DocumentSnapshot _snapshot = await collectionReference.doc(id).get();

    if (_snapshot.exists) {
      await collectionReference.doc(id).update(changes);
    } else {
      throw "Document Not Found";
    }
    DocumentSnapshot _updatedSnapshot = await collectionReference.doc(id).get();
    if (_updatedSnapshot.data() != null) {
      return docFactory
          .fromJson(_updatedSnapshot.data() as Map<String, dynamic>);
    } else {
      throw "Document data is null";
    }
  }

  @override
  Future<bool> setContent(T data) async {
    return collectionReference
        .doc(data.id)
        .set(docFactory.toJson(data))
        .then((value) => true)
        .catchError((e) {
      Get.log(e);
      return false;
    });
  }

  Future<bool> deleteContent(String id) async {
    return collectionReference
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((e) => false);
  }
}
