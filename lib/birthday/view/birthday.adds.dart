import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/birthday/adapter/birthdays.factory.dart';
import 'package:celebrated/birthday/controller/birthdays.controller.dart';
import 'package:celebrated/birthday/model/adding.birthday.stages.dart';
import 'package:celebrated/birthday/model/birthday.dart';
import 'package:celebrated/birthday/model/birthday.list.dart';
import 'package:celebrated/birthday/view/birthday.date.name.dart';
import 'package:celebrated/domain/repository/amen.content/model/query.dart';
import 'package:celebrated/domain/repository/amen.content/model/query.methods.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/pages/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
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
        if (authService.isAuthenticated.isFalse) {
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
class BirthdaysOpenEditor extends AppPageView {
  BirthdaysOpenEditor({Key? key}) : super(key: key);
  static final BirthdaysController controller = Get.find<BirthdaysController>();

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
    if (authService.accountUser.value.uid == board.authorId) {
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
                 navService.to("${AppRoutes.lists}?${board.id}");
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "Can't load this birthday list, its not found ,invalid or expired link.",
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
                  isTextButton: true,
                  onPressed: () {},
                  child: const Text("ask the owner to renew the link or")),
              const SizedBox(
                width: 50,
              ),
              // if (AuthController.instance.isAuthenticated.isFalse)
              AppButton(
                  key: UniqueKey(),
                  child: const Text("Go home"),
                  onPressed: () {
                   navService.to(AppRoutes.home);
                  }),
              // if (AuthController.instance.isAuthenticated.isTrue)
              //   AppButton(
              //       key: UniqueKey(),
              //       child: const Text("retry"),
              //       onPressed: () {
              //         navService.to(Get.currentRoute);
              //       }),
            ],
          ),
        )
      ],
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
          child: NotificationsView(
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
               navService.popParam("success");
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
                  text: "${board.name.contains("list")
                      ? (' birthdays')
                      : " birthday-list"}!",
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
        if (authService.isAuthenticated.isFalse)
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
        if (authService.isAuthenticated.isFalse)
          AppButton(
            onPressed: () {
              FeedbackService.clearErrorNotification();
             navService.to("${AppRoutes.profile}?nextTo=9lists");
            },
            key: UniqueKey(),
            child: Text(
              "Create your 1st BirthdayList",
              style: adapter.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        if (authService.isAuthenticated.isFalse)
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Already have an account?",
              style: adapter.textTheme.bodyText2,
              textAlign: TextAlign.center,
            ),
          ),
        if (authService.isAuthenticated.isFalse)
          AppButton(
            onPressed: () {
              FeedbackService.clearErrorNotification();
             navService.to(AppRoutes.authSignIn);
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


  Widget editView(BirthdayBoard board, Adaptive adapter) {
    return Obx(
          () {
            authService.accountUser.value;
        final TextEditingController _nameEditorController = TextEditingController(
            text: authService.accountUser.value.name);

        final TextEditingController _birthdateController =
        TextEditingController(text: authService.accountUser.value.birthdate.toString());
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
                      text: "@",
                      style: adapter.textTheme.headline6
                          ?.copyWith(fontWeight: FontWeight.w900, color: AppSwatch.primary.shade600),
                    ),
                    TextSpan(
                      text: board.authorName,
                      style:
                      adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w900, color: Colors.red),
                    ),
                    TextSpan(
                      style: adapter.textTheme.headline6,
                      text: " wants to add you to his ",
                    ),
                    TextSpan(
                        text: board.name,
                        style:   adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w900,),
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
                      text: "You have been invited to  ",
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
                "assets/intro/thank_you.png",
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
                      BirthdayDateForm(
                        birthdateController: _birthdateController, nameTextController: _nameEditorController,),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        key: UniqueKey(),
                        child: const Text(
                          "Submit",
                        ),
                        onPressed: () async {
                          if (nameIsValid(_nameEditorController.value.text)) {
                            try {
                              FeedbackService.spinnerUpdateState(
                                  key: FeedbackSpinKeys.appWide, isOn: true);
                              await addBirthday(
                                  board, _nameEditorController.value.text, _birthdateController.value.text);

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
      },
    );
  }

  bool nameIsValid(String name) {
    return name.length >= 2 &&
        name != 'name';
  }

  Future<void> addBirthday(BirthdayBoard board, String name, String date) async {
    final ABirthday birthday = ABirthday.empty().copyWith(
        name: name,
        id: const Uuid().v4(),
        date: DateTime.parse(date));

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
                  () =>
                  CheckboxListTile(
                    title: const Text(
                      'Verify:',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: value.value,
                    onChanged: (bool? state) async {
                      value.toggle();
                      try {
                        await saveData(board, birthday).then((value) => _stage(BirthdayAddStage.successful));
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
        await saveData(board, birthday).then((value) => _stage(BirthdayAddStage.successful));
      }
    }
  }

  Future<BirthdayBoard> saveData(BirthdayBoard board, ABirthday birthday) async {
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
