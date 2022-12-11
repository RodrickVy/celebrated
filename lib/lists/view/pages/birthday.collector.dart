import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/errors/validators.dart';
import 'package:celebrated/domain/services/content.store/model/query.dart';
import 'package:celebrated/domain/services/content.store/model/query.methods.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/pages/loading.dart';
import 'package:celebrated/domain/view/pages/task.stage.pages.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/lists/adapter/birthdays.factory.dart';
import 'package:celebrated/lists/controller/birthdays.controller.dart';
import 'package:celebrated/lists/model/adding.birthday.stages.dart';
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/lists/model/birthday.list.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/app.page.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/models/app.notification.dart';
import 'package:celebrated/support/models/notification.type.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/id.generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

final Rx<BirthdayAddStage> _stage = Rx<BirthdayAddStage>(BirthdayAddStage.adding);
final Future<BirthdayBoard> board = getBoard();

String? viewCode() => Get.parameters["code"];

Future<BirthdayBoard> getBoard() {
  if (viewCode() != null) {
    try {
      return birthdaysController
          .getCollectionAsList(ContentQuery("addingId", QueryMethods.isEqualTo, viewCode()!))
          .then((List<BirthdayBoard> value) {
        if (value.isEmpty) {
          _stage(BirthdayAddStage.notFound);
          return BirthdayBoard.empty();
        }
        if (authService.user.isUnauthenticated) {
          /// asks user to sign up if they are just visiting to view list
          FeedbackService.announceSignUpPromo();
        }
        return value.first;
      }).catchError((_) {
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
class BirthdayCollectionForm extends AppPageView {
  const BirthdayCollectionForm({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
      () {
        _stage.value;
        return Center(
        child: SizedBox(
          width: adapter.adapt(phone: adapter.width, tablet: 600, desktop: 600),
          child: FutureBuilder(
              future: board,
              builder: (_, AsyncSnapshot<BirthdayBoard> snap) {
                if (!snap.hasData) {
                  return const LoadingSpinner();
                }
                switch (_stage.value) {
                  case BirthdayAddStage.notFound:
                    return const TaskFailed(

                      title:
                          "Can't load this birthday list, its not found, its either invalid or has been destroyed by the owner of the list.",
                    );
                  case BirthdayAddStage.failed:
                    return  TaskFailed(buttonAction: (){
                      _stage(BirthdayAddStage.adding);
                      navService.reload();
                    },);
                  case BirthdayAddStage.successful:
                    return const TaskSucceeded(
                      title: "Your birthday has been added!",
                    );
                  case BirthdayAddStage.adding:
                    return _AddBirthdayEditor(snap.data!);
                }
              }),
        ),
      );
      },
    );
  }

}

class _AddBirthdayEditor extends AdaptiveUI {
  final BirthdayBoard board;

  _AddBirthdayEditor(this.board, {super.key});

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
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
                  style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.w900, color: Colors.red),
                ),
                TextSpan(
                  style: adapter.textTheme.headline6,
                  text: " wants to add you to their ",
                ),
                TextSpan(
                  text: '${board.name} list.',
                  style: adapter.textTheme.headline6?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
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
                  style: adapter.textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: board.name.contains("list") ? ('') : "list",
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
          width: adapter.adapt(phone: Get.width - 40, tablet: 400, desktop: 600),
          alignment: Alignment.center,
          child: Card(
            elevation: 2,
            shape: AppTheme.shape,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIFormState.nameField,
                  const SizedBox(
                    height: 10,
                  ),
                  UIFormState.dateField(UIFormState.birthdate.value),
                  const NotificationsView(),
                  const SizedBox(
                    height: 10,
                  ),
                  AppButton(
                    onPressed: () async {
                      if (Validators.userNameValidator.announceValidation(UIFormState.name.value) == null) {
                        try {
                          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: true);
                          await addBirthday(board, UIFormState.name.value, UIFormState.birthdate.value);

                          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
                        } catch (_) {
                          FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.appWide, isOn: false);
                          _stage(BirthdayAddStage.failed);
                        }
                      }
                    },
                    child: const Text(
                      "Submit",
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }



  Future<void> addBirthday(BirthdayBoard board, String name, DateTime date) async {
    final ABirthday birthday =
        ABirthday.empty().copyWith(name: name, id: IDGenerator.generateId(10, board.id), date: date);

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
                child: const Text("Still Submit"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: AppButton(
                onPressed: () async{
                  FeedbackService.clearErrorNotification();
                },
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
        title: "Looks like you match a birthday with someone on this list! Are you sure you not adding this a second time?",
      );
    } else {
      final RxBool value = false.obs;
      if (GetPlatform.isWeb) {
        FeedbackService.blockPrompt(
            title: "Just want to make sure you are human :)",
            child: Obx(
              () => CheckboxListTile(
                title: const Text(
                  'Verify',
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
    return await birthdaysController.updateContent(board.id, {
      "birthdays":
          board.withAddedBirthday(birthday).birthdays.values.map((value) => BirthdayFactory().toJson(value)).toList()
    });
  }
}
