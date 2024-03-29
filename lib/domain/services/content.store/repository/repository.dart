import 'package:celebrated/domain/model/imodel.dart';
import 'package:celebrated/domain/model/imodel.factory.dart';
import 'package:celebrated/domain/services/content.store/interface/content.repository.interface.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

//// a repo that simplifies accessing firestore, handles the serialization,
// with a powerful query pattern lowering down the dev-time and complexity of app.
class ContentStore<T extends IModel, F extends IModelFactory<T>>
    implements IContentStore<T> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final Map<String, List<T>> _cashed = {};

  late T empty;

  late F docFactory;

  late String dbCollectionPath;

  late CollectionReference<Map<String, dynamic>> collectionReference;

  void onContentUpdated(T content) {

  }

  @override
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

  Future<List<T>> filter(List<T> docs, ContentQuery? query) async {
    List<T> data = (await getQueryReference(query)
        .where("id", whereIn: docs.map((e) => e.id).toList())
        .get())
        .docs
        .map((QueryDocumentSnapshot doc) {
      if (doc.data() != null) {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return docFactory.fromJson(doc.data() as Map<String, dynamic>);
      }
    }).toList();

    return data;
  }

  @override
  Query<Map<String, dynamic>> getQueryReference(ContentQuery? query) {
    if (query != null) {
      return whereQueryRef(query)
          .limit(query.limit);
      // .orderBy(query.orderProperty, descending: query.orderDescending);
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

  @override
  Future<List<T>> queryCollection(ContentQuery query) async {
    if (!_cashed.containsKey(query.id)) {
      List<T> data = (await getQueryReference(query).get())
          .docs
          .map((QueryDocumentSnapshot doc) {
        if (doc.data() != null) {
          return docFactory.fromJson(doc.data() as Map<String, dynamic>);
        } else {
          return docFactory.fromJson(doc.data() as Map<String, dynamic>);
        }
      }).toList();
      _cashed.assign(query.id, data);
      return data;
    } else {
      return _cashed[query.id]!;
    }
  }

  @override
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

  @override
  Stream<T> contentStream(String id) {
    return collectionReference
        .doc(id)
        .snapshots()
        .map((DocumentSnapshot event) {
      return docFactory.fromJson(event.data() as Map<String, dynamic>);
    });
  }

  @override
  Future<T> getContent(String id) async {
    DocumentSnapshot snapshot = await collectionReference.doc(id).get();

    if (snapshot.exists && snapshot.data() != null) {
      return docFactory.fromJson(snapshot.data() as Map<String, dynamic>);
    } else {
      throw "Document Not Found";
    }
  }

  @override
  Future<T> updateContent(String id, Map<String, dynamic> changes) async {
    DocumentSnapshot snapshot = await collectionReference.doc(id).get();

    if (snapshot.exists) {
      await collectionReference.doc(id).update(changes);
    } else {
      throw "Document Not Found";
    }
    DocumentSnapshot updatedSnapshot = await collectionReference.doc(id).get();
    if (updatedSnapshot.data() != null) {
      final T doc = docFactory
          .fromJson(updatedSnapshot.data() as Map<String, dynamic>);
    onContentUpdated(doc);
    return doc;
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
      Get.log(e.toString());
      return false;
    });
  }

  @override
  Future<bool> deleteContent(String id) async {
    return collectionReference
        .doc(id)
        .delete()
        .then((value) => true)
        .catchError((e) => false);
  }
}
