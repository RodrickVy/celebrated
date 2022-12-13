// ignore_for_file: prefer_for_elements_to_map_from iterable

import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/card.factory.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:celebrated/domain/services/instances.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsController  with ContentStore<BirthdayCard, BirthdayCardFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final RxMap<String, BirthdayCard> birthdayCards = RxMap<String, BirthdayCard>({});

  BirthdayCard? get currentCard {
    if(Get.parameters['id'] != null  &&  birthdayCards[Get.parameters['id']] != null){
      return birthdayCards[Get.parameters['id']]!;
    }
    return null;
  }


  static final CardsController  _instance = CardsController._();

  CardsController._(){

    auth.authStateChanges().listen((User? authUser) async {
      if (authUser != null) {
        // FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
        final Map<String, BirthdayCard> list =
        Map.fromIterable(await getCollectionAsList(null), key: (e) => e.id, value: (e) => e);
        birthdayCards.value = list;
        // FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
      }
    });
  }

  factory CardsController(){
    return _instance;
  }
  @override
  BirthdayCard get empty => BirthdayCard.empty();

  @override
  BirthdayCardFactory get docFactory => BirthdayCardFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('cards');

  @override
  Future<List<BirthdayCard>> getCollectionAsList(ContentQuery? query) async {
    return await queryCollection(
        query ?? ContentQuery("authorId", QueryMethods.isEqualTo, authService.user.uid));
  }

  @override
  Future<BirthdayCard> updateContent(String id, Map<String, dynamic> changes) async {
    BirthdayCard data = (await super.updateContent(id, {...changes}));
    birthdayCards[id] = data;
    return data;
  }

  @override
  Future<bool> setContent(BirthdayCard data) async {
    birthdayCards[data.id] = data;
    bool success = (await super.setContent(data));
    return success;
  }

  @override
  Future<bool> deleteContent(String id) async {
    bool success = (await super.deleteContent(id));
    birthdayCards.remove(id);
    return success;
  }

  /// creates a new birthday list
  Future<void> createNewCard() async {
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
    if (authService.user.isAuthenticated) {
      final String id = IDGenerator.generateId(10, authService.user.uid);
      final BirthdayCard newCard = BirthdayCard.empty().copyWith(id: id, title: "New Card", image: "1", authorId: authService.user.uid);
      await setContent(newCard);
      navService.to("${AppRoutes.cardEditor}?id=${id}");
    }
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
  }

  final RxString currentBirthdayInEdit = "".obs;

  void editBirthday(String id) {
    // Get.log("This birthday id is -$id-");
    // NavController.instance.withParam("editingBId", id);
    currentBirthdayInEdit(id);
  }

  void closeBirthdayEditor() {
    // NavController.instance.popParam("editingBId");
    // Get.back();
    currentBirthdayInEdit("");
  }

  Future<BirthdayCard> boardFromViewId() async {
    if (Get.parameters["id"] != null) {
      try {
        return (getCollectionAsList(ContentQuery("id", QueryMethods.isEqualTo, Get.parameters["id"]!))).then((value) {
          if (value.isEmpty) {
            return BirthdayCard.empty();
          }
          if (authService.user.isAuthenticated) {
            /// asks user to sign up if they are just visiting to view list
            FeedbackService.announceSignUpPromo();
          }

          return value.first;
        }).catchError((_) => throw _.message);
      } catch (_) {
        return BirthdayCard.empty();
      }
    } else {
      return BirthdayCard.empty();
    }
  }
}

final CardsController cardsController = CardsController();
