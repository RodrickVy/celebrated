// import 'dart:async';
//
// import 'package:bremind/account/interface/account.interface.dart';
// import 'package:bremind/account/models/account.dart';
// import 'package:bremind/authenticate/controller/auth.controller.dart';
// import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
// import 'package:bremind/authenticate/models/auth.user.dart';
// import 'package:bremind/authenticate/models/auth.with.dart';
// import 'package:bremind/domain/repository/amen.content/model/query.dart';
// import 'package:bremind/domain/repository/amen.content/model/query.methods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:get/get.dart';
//
// class AccountController extends GetxController implements IAccountInterface {
//   final IAuthController authController = Get.find<AuthController>();
//   static FirebaseFirestore firestore = FirebaseFirestore.instance;
//   static FirebaseStorage storage = FirebaseStorage.instance;
//
//   late final CollectionReference<Map<String, dynamic>> __collectionReference =
//       firestore.collection("users");
//
//   AccountController();
//
//   @override
//   onInit() {
//     super.onInit();
//     authController.user.listen((AuthUser user)async {
//       /// check if the user has just logged in and request for thier data has been made
//       if (!user.isEmpty()) {
//         print("Attempting to fetch user for ${user.toMap()}");
//         await attemptFetchUserAccount(user);
//       }
//     });
//   }
//
//   @override
//   final Rx<AccountUser> accountUser = AccountUser.empty().obs;
//
//   @override
//   Future<AccountUser> attemptFetchUserAccount(AuthUser user) async {
//     try {
//       return await getContent(user.uid).then((AccountUser value) async {
//         // find the user meaning this is just a login in, and now updating their last login to match now
//         await updateContent(
//                 user.uid, {'lastLogin': DateTime.now().millisecondsSinceEpoch})
//             .then((value) {});
//         return value;
//       });
//     } on FirebaseAuthException catch (_) {
//       print("e");
//       return createUserAccount(user);
//     } catch (_) {
//       return accountUser.value;
//     }
//
//     //
//     //     .catchError((onError){
//     //   /// if the erorcode is not found then the user doesnt exist
//     // });
//   }
//
//   @override
//   Future<AccountUser> createUserAccount(AuthUser user) async {
//     bool success = await setContent(AccountUser(
//         claims: {},
//         timeCreated: DateTime.now(),
//         interactions: [],
//         name: user.userName,
//         bio: "",
//         emailVerified: user.emailVerified,
//         uid: user.uid,
//         lastLogin: DateTime.now(),
//         authMethod: AuthWith.Password,
//         avatar: user.avatar,
//         displayName: user.userName,
//         providerId: "",
//         email: user.email,
//         photoUrl: user.avatar,
//         phone: user.phoneNumber ?? ""));
//     if(success){
//       return await attemptFetchUserAccount(user);
//     }else{
//       return accountUser.value;
//     }
//
//   }
//
//   Future<List<AccountUser>> getCollectionAsList(ContentQuery? query) async {
//     return (await getQueryReference(query).get())
//         .docs
//         .map((QueryDocumentSnapshot doc) {
//       if (doc.data() != null) {
//         return AccountUser.fromMap(doc.data() as Map<String, dynamic>);
//       } else {
//         return AccountUser.fromMap(doc.data() as Map<String, dynamic>);
//       }
//     }).toList();
//   }
//
//   Query<Map<String, dynamic>> getQueryReference(ContentQuery? query) {
//     if (query != null) {
//       switch (query.method) {
//         case QueryMethods.isEqualTo:
//           return __collectionReference
//               .where(query.property, isEqualTo: query.value)
//               .limit(query.limit);
//         case QueryMethods.isNotEqualTo:
//           return __collectionReference
//               .where(query.property, isNotEqualTo: query.value)
//               .limit(query.limit);
//         case QueryMethods.isLessThan:
//           return __collectionReference
//               .where(query.property, isLessThan: query.value)
//               .limit(query.limit);
//         case QueryMethods.isLessThanOrEqualTo:
//           return __collectionReference
//               .where(query.property, isLessThanOrEqualTo: query.value)
//               .limit(query.limit);
//         case QueryMethods.isGreaterThan:
//           return __collectionReference
//               .where(query.property, isGreaterThan: query.value)
//               .limit(query.limit);
//         case QueryMethods.isGreaterThanOrEqualTo:
//           return __collectionReference
//               .where(query.property, isGreaterThanOrEqualTo: query.value)
//               .limit(query.limit);
//         case QueryMethods.arrayContains:
//           return __collectionReference
//               .where(query.property, arrayContains: query.value)
//               .limit(query.limit);
//         case QueryMethods.arrayContainsAny:
//           return __collectionReference
//               .where(query.property, arrayContainsAny: query.value as List)
//               .limit(query.limit);
//         case QueryMethods.whereIn:
//           return __collectionReference
//               .where(query.property, whereIn: query.value as List)
//               .limit(query.limit);
//         case QueryMethods.whereNotIn:
//           return __collectionReference
//               .where(query.property, whereNotIn: query.value as List)
//               .limit(query.limit);
//         case QueryMethods.isNull:
//           return __collectionReference
//               .where(query.property, isNull: true)
//               .limit(query.limit);
//       }
//     } else {
//       return __collectionReference;
//     }
//   }
//
//   Future<List<AccountUser>> queryCollection(ContentQuery query) async {
//     return (await getQueryReference(query).get())
//         .docs
//         .map((QueryDocumentSnapshot doc) {
//       if (doc.data() != null) {
//         return AccountUser.fromMap(doc.data() as Map<String, dynamic>);
//       } else {
//         return AccountUser.fromMap(doc.data() as Map<String, dynamic>);
//       }
//     }).toList();
//   }
//
//   Stream<List<AccountUser>> collectionStream(ContentQuery? query) {
//     return getQueryReference(query).snapshots().map((QuerySnapshot event) {
//       return event.docChanges.map((e) {
//         if (e.doc.data() != null) {
//           return AccountUser.fromMap(e.doc.data() as Map<String, dynamic>);
//         } else {
//           return AccountUser.fromMap(e.doc.data() as Map<String, dynamic>);
//         }
//       }).toList();
//     });
//   }
//
//   Stream<AccountUser> contentStream(String id) {
//     return __collectionReference
//         .doc(id)
//         .snapshots()
//         .map((DocumentSnapshot event) {
//       return AccountUser.fromMap(event.data() as Map<String, dynamic>);
//     });
//   }
//
//   Future<AccountUser> getContent(String id) async {
//     DocumentSnapshot _snapshot = await __collectionReference.doc(id).get();
//
//     if (_snapshot.exists && _snapshot.data() != null) {
//       return AccountUser.fromMap(_snapshot.data() as Map<String, dynamic>);
//     } else {
//       throw "Document Not Found";
//     }
//   }
//
//   Future<AccountUser> updateContent(
//       String id, Map<String, dynamic> changes) async {
//     DocumentSnapshot _snapshot = await __collectionReference.doc(id).get();
//
//     if (_snapshot.exists) {
//       __collectionReference.doc(id).update(changes);
//     } else {
//       throw "Document Not Found";
//     }
//     if (_snapshot.data() != null) {
//       return AccountUser.fromMap(_snapshot.data() as Map<String, dynamic>);
//     } else {
//       throw "Document data is null";
//     }
//   }
//
//   Future<bool> setContent(AccountUser data) async {
//     return __collectionReference
//         .doc(data.uid)
//         .set(data.toMap())
//         .then((value) => true)
//         .catchError((e) => false);
//   }
//
//   Future<bool> deleteContent(String id) async {
//     return __collectionReference
//         .doc(id)
//         .delete()
//         .then((value) => true)
//         .catchError((e) => false);
//   }
// }
