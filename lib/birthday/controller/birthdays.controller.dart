import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/notification.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/domain/repository/amen.content/repository/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

class BirthdaysController extends GetxController
    with ContentRepository<ABirthday, BirthdayFactory> {

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;
  Rx<List<ABirthday>?> birthdays = Rx<List<ABirthday>?>(null);

  Rx<ABirthday?> birthdayToUpdate = Rx<ABirthday?>(null);
  BirthdaysController();

  static List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static List<String> monthsShortForm = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static BirthdaysController instance = Get.find<BirthdaysController>();

  static RxBool editMode = RxBool(false);

  @override
  final ABirthday empty = ABirthday.empty();

  @override
  final BirthdayFactory docFactory = BirthdayFactory();

  @override
  CollectionReference<Map<String, dynamic>> get collectionReference =>
      firestore.collection(
          'users/${AuthController.instance.accountUser.value.uid}/birthdays');

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? fireUser) async {
      if (AuthController.instance.isAuthenticated.value) {}
    });

    FeedbackController.appNotification.listen((AppNotification? error) {
      if (error != null) {
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.signUpForm, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.signInForm, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.authProviderButtons, isOn: false);
        FeedbackController.spinnerUpdateState(
            key: AfroSpinKeys.passResetForm, isOn: false);
      }
    });
  }

  getBirthdays() async {
    List<ABirthday> _birthdays =
        (await BirthdaysController.instance.getCollectionAsList(null));
    _birthdays.sort((a, b) {


      int aDifferenceToCurrentDate = DateTime.now()
          .difference(DateTime(DateTime.now().year, a.date.month, a.date.day))
          .inMicroseconds
          .abs();
      int bDifferenceToCurrentDate = DateTime.now()
          .difference(DateTime(DateTime.now().year, b.date.month, b.date.day))
          .inMicroseconds
          .abs();
      if (b.isPast) {
        return -1;
      }
      if (a.isPast) {
        return 1;
      }
      if (aDifferenceToCurrentDate < bDifferenceToCurrentDate) {
        return -1;
      } else {
        return 1;
      }
    });
    birthdays(_birthdays);
    _birthdays.forEach((ABirthday element) {
      if(element.shouldNotify){
        // NotificationService().showBirthdayNotification(_birthdays.first);
      }
    });
  }
}
