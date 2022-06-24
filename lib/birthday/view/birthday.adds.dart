import 'package:bremind/app.theme.dart';
import 'package:bremind/authenticate/controller/auth.controller.dart';
import 'package:bremind/authenticate/models/account.dart';
import 'package:bremind/birthday/adapter/birthdays.factory.dart';
import 'package:bremind/birthday/controller/birthdays.controller.dart';
import 'package:bremind/birthday/model/adding.birthday.stages.dart';
import 'package:bremind/birthday/model/birthday.dart';
import 'package:bremind/birthday/model/birthday.list.dart';
import 'package:bremind/birthday/view/birthday.editor.dart';
import 'package:bremind/domain/repository/amen.content/model/query.dart';
import 'package:bremind/domain/repository/amen.content/model/query.methods.dart';
import 'package:bremind/domain/view/app.button.dart';
import 'package:bremind/domain/view/app.page.view.dart';
import 'package:bremind/domain/view/app.text.field.dart';
import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:bremind/support/controller/feedback.controller.dart';
import 'package:bremind/support/controller/spin.keys.dart';
import 'package:bremind/support/models/app.notification.dart';
import 'package:bremind/support/models/notification.type.dart';
import 'package:bremind/support/view/feedback.spinner.dart';
import 'package:bremind/support/view/notification.view.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:uuid/uuid.dart';

final Rx<BirthdayAddStage> _stage =
    Rx<BirthdayAddStage>(BirthdayAddStage.adding);
final Future<BirthdayBoard> board = getBoard();

Future<BirthdayBoard> getBoard() {
  if (Get.parameters["link"] != null) {
    try {
      return BirthdaysController.instance
          .getCollectionAsList(ContentQuery(
              "addingId", QueryMethods.isEqualTo, Get.parameters["link"]!))
          .then((List<BirthdayBoard> value) {
        if (value.isEmpty) {
          _stage(BirthdayAddStage.notFound);
          return BirthdayBoard.empty();
        }
        if (AuthController.instance.isAuthenticated.isFalse) {
          /// asks user to sign up if they are just visiting to view list
          FeedbackService.announceSignUpPromo();
        }
        return value.first;
      }).catchError((_) {
        Get.log(_.message.toString());
        _stage(BirthdayAddStage.notFound);
        return Future.value(BirthdayBoard.empty());
      });
    } catch (_) {
      _stage(BirthdayAddStage.notFound);
      return Future.value(BirthdayBoard.empty());
    }
  } else {
    _stage(BirthdayAddStage.notFound);
    return Future.value(BirthdayBoard.empty());
  }
}

/// page showing the users birthdays , and enables the user to update the lists.
class BirthdaysOpenEditor extends AppPageView<BirthdaysController> {
  BirthdaysOpenEditor({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        _stage.value;
        return Center(
          child: SizedBox(
            width:
                adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
            child: FutureBuilder(
                future: board,
                builder: (_, AsyncSnapshot<BirthdayBoard> snap) {
                  if (snap.hasData) {
                    final BirthdayBoard board = snap.data!;
                    announce(board);

                    switch (_stage.value) {
                      case BirthdayAddStage.notFound:
                        return onEmpty;
                      case BirthdayAddStage.adding:
                        return editView(board, adapter);
                      case BirthdayAddStage.successful:
                        return onSubmissionSuccessful(board, adapter);
                      case BirthdayAddStage.failed:
                        return onSubmissionFailed(board, adapter);
                    }
                  } else {
                    return loadingView(adapter);
                  }
                }),
          ),
        );
      },
    );
  }

  announce(BirthdayBoard board) {
    if (AuthController.instance.user.value.uid == board.authorId) {
      /// give edit option is user is the owner of this list
      FeedbackService.announce(
          notification: AppNotification.empty().copyWith(
        title: "This list is yours",
        type: NotificationType.neutral,
        appWide: false,
        child: TextButton(
            key: UniqueKey(),
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              NavController.instance.to("${AppRoutes.lists}?${board.id}");
            }),
      ));
    }
  }

  Widget loadingView(Adaptive adapter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SpinKitSpinningCircle(
          color: adapter.theme.colorScheme.primary,
        ),
        const Text("getting things ready...")
      ],
    );
  }

  Widget get onEmpty {
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "Can't load this birthday list, its not found , maybe the author has taken it down.",
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("Sorry for this, you can now"),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    key: UniqueKey(),
                    child: const Text("Go Back"),
                    onPressed: () {
                      NavController.instance.back();
                    }),
                const SizedBox(
                  width: 50,
                ),
                if (AuthController.instance.isAuthenticated.isFalse)
                  AppButton(
                      key: UniqueKey(),
                      child: const Text("Check Us Out"),
                      onPressed: () {
                        NavController.instance.to(AppRoutes.splash);
                      }),
                if (AuthController.instance.isAuthenticated.isTrue)
                  AppButton(
                      key: UniqueKey(),
                      child: const Text("retry"),
                      onPressed: () {
                        Get.toNamed(Get.currentRoute);
                      }),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget get notificationHolder {
    return Obx(
      () {
        if (FeedbackService.appNotification.value == null) {
          return const SizedBox();
        }
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: AppTheme.themeData.colorScheme.primary.withAlpha(380),
          ),
          padding: const EdgeInsets.all(2),
          child: NotificatonsView(
            key: UniqueKey(),
          ),
        );
      },
    );
  }

  Widget onSubmissionFailed(BirthdayBoard board, Adaptive adapter) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "We sorry for this looks like something went wrong",
            style: adapter.textTheme.bodyText2?.copyWith(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "You Are invited to add your birthday to the ${board.name} list",
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppButton(
              key: const Key(""),
              label: "Retry Again",
              onPressed: () {
                NavController.instance.popParam("success");
              }),
        ),
        notificationHolder
      ],
    );
  }

  Widget onSubmissionSuccessful(BirthdayBoard board, Adaptive adapter) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        if (board.authorName.isNotEmpty)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: adapter.textTheme.headline6, children: [
                TextSpan(
                  text: "You have been added to ",
                  style: adapter.textTheme.headline6,
                ),
                TextSpan(
                  text: "@${board.authorName} 's\n",
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                TextSpan(
                  text: board.name,
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: (board.name.contains("list")
                          ? (' birthdays')
                          : " birthday-list") +
                      "!",
                )
              ]),
            ),
          ),
        if (board.authorName.isEmpty)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: adapter.textTheme.headline6, children: [
                const TextSpan(
                  text: "Your birthday has been added to  ",
                ),
                TextSpan(
                  text: board.name,
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: board.name.contains("list")
                      ? (' birthdays')
                      : " birthday-list",
                )
              ]),
            ),
          ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/intro/cake_time.png",
            width: 200,
          ),
        ),
        if (AuthController.instance.isAuthenticated.isFalse)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Want to make belated birthdays a thing of the past?",
                    style: adapter.textTheme.headline6,
                  ),
                  TextSpan(
                    text: "We remind you when it matters!",
                    style: adapter.textTheme.subtitle2,
                  )
                ])),
          ),
        if (AuthController.instance.isAuthenticated.isFalse)
          AppButton(
            onPressed: () {
              FeedbackService.clearErrorNotification();
              NavController.instance.to("${AppRoutes.auth}?nextTo=9lists");
            },
            key: UniqueKey(),
            child: Text(
              "Create your 1st BirthdayList",
              style: adapter.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        if (AuthController.instance.isAuthenticated.isFalse)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Already have an account?",
              style: adapter.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        if (AuthController.instance.isAuthenticated.isFalse)
          AppButton(
            onPressed: () {
              FeedbackService.clearErrorNotification();
              NavController.instance.to(AppRoutes.authSignIn);
            },
            key: UniqueKey(),
            child: Text(
              "Sign In",
              style: adapter.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }

  final ABirthday newBirthday =
      ABirthday.empty().copyWith(id: const Uuid().v4());

  final TextEditingController _nameEditorController = TextEditingController(
      text: AuthController.instance.accountUser.value.displayName);
  final TextEditingController _birthdateController =
      TextEditingController(text: DateTime.now().toString());

  Widget editView(BirthdayBoard board, Adaptive adapter) {
    return ListView(
      children: [
        const SizedBox(
          height: 10,
        ),
        if (board.authorName.isNotEmpty)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: adapter.textTheme.headline6, children: [
                TextSpan(
                  text: "@${board.authorName} \n",
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.w900),
                ),
                const TextSpan(
                  text: " has invited you to their ",
                ),
                TextSpan(
                  text: board.name,
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: board.name.contains("list")
                      ? (' birthdays')
                      : " birthday-list",
                )
              ]),
            ),
          ),
        if (board.authorName.isEmpty)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(style: adapter.textTheme.headline6, children: [
                const TextSpan(
                  text: "you have been invited to  ",
                ),
                TextSpan(
                  text: board.name,
                  style: adapter.textTheme.headline6
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: board.name.contains("list")
                      ? (' birthdays')
                      : " birthday-list",
                )
              ]),
            ),
          ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/intro/cake_time.png",
            width: 200,
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Add your birthday details below and submit!",
            style: adapter.textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width:
              adapter.adapt(phone: Get.width - 40, tablet: 400, desktop: 600),
          alignment: Alignment.center,
          child: Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 60,
                    width: Get.width - 20,
                    child: AppTextField(
                      label: "Name",
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(0),
                              borderSide: const BorderSide(width: 0.5))),
                      controller: _nameEditorController,
                      hint: 'full name',
                      key: const Key("birthday_name"),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DateTimePicker(
                    type: DateTimePickerType.date,
                    dateMask: 'd MMM, yyyy',
                    fieldLabelText: 'Birthdate',
                    firstDate: DateTime(1200),
                    controller: _birthdateController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0),
                            borderSide: const BorderSide(width: 0.5))),
                    lastDate: DateTime(9090),
                    icon: const Icon(Icons.event),
                    dateLabelText: 'Birthdate',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppButton(
                    key: UniqueKey(),
                    child: const Text(
                      "Submit",
                    ),
                    onPressed: () async {
                      if (nameIsValid) {
                        try {
                          FeedbackService.spinnerUpdateState(
                              key: FeedbackSpinKeys.appWide, isOn: true);
                          await addBirthday(board);

                          FeedbackService.spinnerUpdateState(
                              key: FeedbackSpinKeys.appWide, isOn: false);
                        } catch (_) {
                          FeedbackService.spinnerUpdateState(
                              key: FeedbackSpinKeys.appWide, isOn: false);
                          _stage(BirthdayAddStage.failed);
                        }
                      } else {
                        FeedbackService.announce(
                            notification: AppNotification.empty().copyWith(
                                title:
                                    "The name given is empty or invalid,make sure its longer than 1 character"));
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ),
        notificationHolder,
      ],
    );
  }

  bool get nameIsValid {
    return _nameEditorController.value.text.length >= 2 &&
        _nameEditorController.value.text != 'name';
  }

  Future<void> addBirthday(BirthdayBoard board) async {
    final ABirthday birthday = ABirthday.empty().copyWith(
        name: _nameEditorController.value.text,
        id: const Uuid().v4(),
        date: DateTime.parse(_birthdateController.value.text));

    if (board.birthdayAlreadyExists(birthday)) {
      FeedbackService.blockPrompt(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                onPressed: () async {
                  await saveData(board, birthday);
                  FeedbackService.clearErrorNotification();
                  _stage(BirthdayAddStage.successful);
                },
                key: UniqueKey(),
                child: const Text("Still Submit"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                onPressed: () {
                  FeedbackService.clearErrorNotification();
                },
                key: UniqueKey(),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
        title:
            "Looks like you match a birthday with someone on this list! Are you sure you not adding this a second time?",
      );
    } else {
      final RxBool value = false.obs;
      if (GetPlatform.isWeb) {
        FeedbackService.blockPrompt(
            title: "Just want to make sure you are human :)",
            child: Obx(
              () => CheckboxListTile(
                title: const Text(
                  'Verify:',
                  style: TextStyle(color: Colors.black),
                ),
                value: value.value,
                onChanged: (bool? state) async {
                  value.toggle();
                  try {
                    await saveData(board, birthday);
                    FeedbackService.clearErrorNotification();
                  } catch (_) {
                    _stage(BirthdayAddStage.failed);
                    FeedbackService.clearErrorNotification();
                  }
                },
                secondary: const Icon(Icons.security),
              ),
            ));
      } else {
        await saveData(board, birthday);
      }
      _stage(BirthdayAddStage.successful);
    }
  }

  Future<BirthdayBoard> saveData(
      BirthdayBoard board, ABirthday birthday) async {
    return await controller.updateContent(board.id, {
      "birthdays": board
          .withAddedBirthday(birthday)
          .birthdays
          .values
          .map((value) => BirthdayFactory().toJson(value))
          .toList()
    });
  }
}
