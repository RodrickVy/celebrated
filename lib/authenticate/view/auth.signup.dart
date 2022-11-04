import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/birthday/view/birthday.date.name.dart';
import 'package:celebrated/domain/model/drop.down.action.dart';
import 'package:celebrated/domain/view/app.button.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/domain/view/app.text.field.dart';
import 'package:celebrated/domain/view/drop.down.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/feedback.spinner.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'auth.button.dart';

/// auth sign up form , for authentication this is not a page just the form.
// ignore: must_be_immutable
class SignUpFormView extends AppStateView<AuthController> {
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController(
      text: DateTime.now().toString());

  SignUpFormView({Key? key}) : super(key: key);

  final List<String> typeOfOrgs =  ["select","School","Class","Church","Business","Company","Other"];

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Center(
      child: SizedBox(
        width: 320,
        child: ListView(
          children: [
            SizedBox(height: 50,),
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.all(10.0),
            //     color: Colors.yellow,
            //     height: 100,
            //     child: ClipRect(
            //       child: Banner(
            //         message: "Offer",
            //         location: BannerLocation.topEnd,
            //         color: Colors.red,
            //         child: Container(
            //           color: Colors.yellow,
            //           height: 100,
            //           child: Center(
            //             child: Text("Free Offer, for our pre-launch users!"),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            // PricingCards(
            //   pricingCards: [
            //     PricingCard(
            //       title: 'Monthly',
            //       price: '\$ 6.99',
            //       subPriceText: '\/mo',
            //       billedText: 'Billed monthly',
            //       onPress: () {
            //         // make your business
            //       },
            //     ),
            //     PricingCard(
            //       title: 'Monthly',
            //       price: '\$ 0',
            //       subPriceText: '\/mo',
            //       billedText: 'Free',
            //       mainPricing: true,
            //       mainPricingHighlightText: 'Pre-launch Offer',
            //       onPress: () {
            //         // make your business
            //       },
            //     )
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            // ProviderButtons(
            //   key: UniqueKey(),
            //
            // ),
            FeedbackSpinner(
              spinnerKey: FeedbackSpinKeys.signUpForm,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        BirthdayDateForm(
                            showDate: false,
                            nameTextController: nameTextController),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.email,
                          label: "Email",
                          hint: "eg. example@gmail.com",
                          controller: emailTextController,
                          key: UniqueKey(),
                          keyboardType: TextInputType.emailAddress,
                          autoFillHints: const [AutofillHints.email],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AppTextField(
                          fieldIcon: Icons.vpn_key,
                          label: "Password",
                          hint: "minimum 6 characters",
                          controller: passwordTextController,
                          obscureOption: true,
                          key: UniqueKey(),
                          keyboardType: TextInputType.visiblePassword,
                          autoFillHints: const [AutofillHints.password],
                        ),
                        const SizedBox(height: 10,),
                        Wrap(
                          children: [
                            Text("Type of organization(optional): "),
                            Container(constraints:BoxConstraints(maxWidth: 400),child: ButtonDropDown(actions: typeOfOrgs.map((e) => DropDownAction(e, Icons.access_time, () { })).toList(),)),
                          ],
                        ),
                        // AppToggleButton(
                        //   multiselect: true,
                        //   options: [
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Just Me"),
                        //     ), state: true, onSelected: (){}),
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Youth Group"),
                        //     ), state: false, onSelected: (){}),
                        //     ToggleOption(view: Padding(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child: const Text("Organization"),
                        //     ), state: false, onSelected: (){}),
                        //   ],
                        //
                        // ),

                        const SizedBox(
                          height: 10 / 2,
                        ),

                        const NotificatonsView(),
                        const SizedBox(
                          height: 10 / 2,
                        ),
                        AppButton(
                          key: UniqueKey(),
                          child: Text(
                            "Sign Up",
                            style: GoogleFonts.poppins(fontSize: 16),
                          ),
                          onPressed: () async {
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signUpForm, isOn: true);
                            await controller.signUpWithEmail(
                                name: nameTextController.value.text,
                                email: emailTextController.value.text,
                                birthdate:  DateTime.parse(_birthdateController.value.text),
                                password: passwordTextController.value.text);
                            FeedbackService.spinnerUpdateState(
                                key: FeedbackSpinKeys.signUpForm, isOn: false);
                          },
                        ),
                      ]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
