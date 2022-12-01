import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/components/app.text.field.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/subscription/controller/subscription.service.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/subscription/view/subscription.card.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/support/view/notification.view.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionsPage extends AdaptiveUI {
  const SubscriptionsPage({super.key});


  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return   Container(
      alignment: Alignment.center,
      child: SizedBox(
        width: 320,
        height: Get.height,
        child: ListView(
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Select a plan", style: adapter.textTheme.headlineSmall),
                  ),
                  SizedBox(height: 10,),
                  ...subscriptionService.subscriptions.map((Subscription subscription) {
                    return GestureDetector(
                      onTap: (){
                        UIFormState.subscriptionPlan(subscription.id);
                      },
                      child:  Opacity(opacity:subscription.id == SubscriptionPlan.test ? 1:0.3,child: SubscriptionCard(subscription:subscription)),
                    );
                  }),

                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("have a promo code?"),
                  ),
                  AppTextField(
                    label: "promo code(optional)",
                    fieldIcon: Icons.key,
                    decoration: AppTheme.inputDecoration,
                    controller: TextEditingController(text: UIFormState.signUpFormData.promotionCode),
                    onChanged: (data) {
                      UIFormState.promoCode(data);
                    },
                    hint: 'BD-##-##-###',
                    autoFillHints: const [AutofillHints.password],
                    key: UniqueKey(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const NotificationsView(),
                  const SizedBox(
                    height: 10,
                  ),
                  AppButton(
                    key: UniqueKey(),
                    child: Text(
                      "Checkout",
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                    onPressed: () async {
                      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: true);
                      await authService.setSubscriptionPlan(UIFormState.subscriptionPlan.value,UIFormState.promoCode.value);
                      FeedbackService.spinnerUpdateState(key: FeedbackSpinKeys.signUpForm, isOn: false);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}

