// ignore_for_file: prefer_for_elements_to_map_from iterable

import 'package:celebrated/authenticate/models/account.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/card.factory.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.template.dart';
import 'package:celebrated/domain/services/app.initializing.state.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class GamesController extends GetxController with ContentStore<BirthdayCard, BirthdayCardFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  RxMap<String, BirthdayCard> birthdayCards = RxMap<String, BirthdayCard>({});

  Rx<BirthdayCard> cardInCreation = BirthdayCard.empty().obs;

  final List<CardTemplate> templates = [
    GifCardTemplate(
        id: "",
        image: '',
        name: '',
        keywords: [],
        topGift: '',
        bottomGif: '',
        backGift: '',
        availableIn: SubscriptionPlan.test),
  ];

  static GamesController instance = Get.find<GamesController>();

  @override
  BirthdayCard get empty => BirthdayCard.empty();

  @override
  BirthdayCardFactory get docFactory => BirthdayCardFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('cards');

  @override
  void onInit() {
    super.onInit();
    authService.userLive.listen((UserAccount user) async {
      if (user.isAuthenticated) {
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
        birthdayCards({for (var e in await getCollectionAsList(null)) e.id: e});
        FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
      }
    });
  }

  @override
  Future<List<BirthdayCard>> getCollectionAsList(ContentQuery? query) async {
    return await queryCollection(
        query ?? ContentQuery("authorId", QueryMethods.isEqualTo, authService.userLive.value.uid));
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
      final BirthdayCard newCard = BirthdayCard.empty().copyWith(id: id, authorId: authService.user.uid);
      await setContent(newCard);
      cardInCreation(newCard);
      navService.to(AppRoutes.createCard);
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

final GamesController cardsController = GamesController();
