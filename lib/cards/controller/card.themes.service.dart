import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/cards/adapter/card.theme.factory.dart';
import 'package:celebrated/cards/model/card.theme.dart';
import 'package:celebrated/domain/errors/app.errors.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/content.store/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

final CelebrationCardThemesService cardThemesService = CelebrationCardThemesService();

class CelebrationCardThemesService extends GetxController
    with ContentStore<CelebrationCardTheme, CelebrationCardThemeFactory> {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  final RxList<CelebrationCardTheme> themes = RxList<CelebrationCardTheme>([...themesList]);

  @override
  CelebrationCardTheme get empty => CelebrationCardTheme.empty();

  @override
  CelebrationCardThemeFactory get docFactory => CelebrationCardThemeFactory();

  static List<CelebrationCardTheme> get themesList => [
    CelebrationCardTheme(
      cardFront: 'https://firebasestorage.googleapis.com/v0/b/celebrated-app.appspot.com/o/cards%2Fcard_7_5_blow_away_back.gif?alt=media&token=bd6142e7-1b6d-45cd-9aad-e200d75ab0eb',
      id: 'cast_shadow',
      cardBack: 'https://firebasestorage.googleapis.com/v0/b/celebrated-app.appspot.com/o/cards%2Fcard_7_5_blow_away.gif?alt=media&token=490f3cf6-e207-4b3d-8da6-5bdfe8f99c70',
      supportsText: true,
      textStyle: CardTextStyle.fromTextStyle(GoogleFonts.aclonica(fontWeight:FontWeight.w100,backgroundColor:  Colors.white,color: Colors.black26), TextAlign.left),
      cardRatio: const XYPair(7,5),
      texPosition: const XYPair(66,50),
    ),
  ];

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference => firestore.collection('card_themes');

  static CelebrationCardThemesService? _instance;

  CelebrationCardThemesService._(){

    // print("setting content authed:${authService.userLive.value.isAuthenticated}");
    //  setContent(themesList.first).then((value){
    //    print("updated content");
    //    print("setting content authed:${authService.userLive.value.isAuthenticated}");
    //    print(value);
    //  });
    // collectionStream(ContentQuery("id", QueryMethods.isNotEqualTo, 'null'))
    //     .listen((List<CelebrationCardTheme> newThemes) {
    //   themes(newThemes);
    // }, onError: (Object e,StackTrace trace) {
    //   AnnounceErrors.unknown(e);
    // });
    themes(themesList);
  }

  factory CelebrationCardThemesService() {
    _instance ??= CelebrationCardThemesService._();
    return _instance!;
  }


}
