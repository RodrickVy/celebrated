
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/card.factory.dart';
import 'package:celebrated/cards/model/card.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final CardsController cardsController = CardsController();

class CardsController extends GetxController with ContentStore<CelebrationCard, CelebrationCardFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final RxMap<String, CelebrationCard> birthdayCards = RxMap<String, CelebrationCard>({});

  /// used to retrieve the current card as reflected in the route using the id parameter
  Future<CelebrationCard?> get cardFromUrlParam async {
    if (Get.parameters['id'] != null) {
      if (birthdayCards[Get.parameters['id']] != null) {
        return birthdayCards[Get.parameters['id']]!;
      } else {
        return await getContent(Get.parameters['id']!);
      }
    }

    return null;
  }

  /// the current index of the sign we are when signing a card

  static CardsController? _instance;
  final RxInt currentSignIndex = 0.obs;
  CardsController._();

  factory CardsController() {
    _instance ??= CardsController._();
    return _instance!;
  }

  Future<CelebrationCard> getCardById(String id)async{

      if (birthdayCards.containsKey(id)) {
        return birthdayCards[id]!;
      } else {
        return await getContent(id);
      }


  }

  Future<void> updateDataFromStore() async {
    final Map<String, CelebrationCard> list =
        Map.fromIterable(await cardsController.getCollectionAsList(null), key: (e) => e.id, value: (e) => e);
    cardsController.birthdayCards.value = list;
    print("updated the UI");
  }

  void clearData() {
    birthdayCards.assignAll({});
  }

  @override
  CelebrationCard get empty => CelebrationCard.empty();

  @override
  CelebrationCardFactory get docFactory => CelebrationCardFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('cards');



  @override
  Future<List<CelebrationCard>> getCollectionAsList(ContentQuery? query) async {
    return await queryCollection(query ?? ContentQuery("authorId", QueryMethods.isEqualTo, authService.user.uid));
  }

  @override
  Future<CelebrationCard> updateContent(String id, Map<String, dynamic> changes) async {
    CelebrationCard data = (await super.updateContent(id, {...changes}));
    birthdayCards[id] = data;
    return data;
  }

  @override
  Future<bool> setContent(CelebrationCard data) async {
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
      final CelebrationCard newCard =
          CelebrationCard.empty().copyWith(id: id, title: "New Card", themeId: 'default', authorId: authService.user.uid);
      await setContent(newCard);
      navService.to("${AppRoutes.cardEditor}?id=$id");
    }
    FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
  }
}

