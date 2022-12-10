import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/service/auth.service.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/components/app.button.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/controller/route.names.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/support/controller/feedback.controller.dart';
import 'package:celebrated/support/controller/spin.keys.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionPreviewCard extends AdaptiveUI {
  final Subscription subscription;
  const SubscriptionPreviewCard({
    Key? key, required this.subscription,
  }) : super(key: key);



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Card(
        shape: AppTheme.shape
            .copyWith(side:  BorderSide(width: 4,style: BorderStyle.solid, color:AppSwatch.primary.shade600)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(subscription.name,style: adapter.textTheme.headlineSmall, ),
              Text("\$${subscription.price}/mo",style: adapter.textTheme.bodyLarge, ),
              Text(subscription.description,style: adapter.textTheme.bodyMedium, ),
              const SizedBox(height: 30,),
              button,
              // cancelButton,
              const SizedBox(height: 10,),
              ExpansionTile(
                title: const Text("features"),
                initiallyExpanded: UIFormState.subscriptionPlan.value == subscription.id,
                children: [

                  ...subscription.featureAccess.map((e){
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: ListTile(

                        title: Text(e.name,style: adapter.textTheme.bodyMedium,textAlign: TextAlign.center,),
                        tileColor: Colors.black12.withAlpha(5),
                        // subtitle: Text(e.limit),
                      ),
                    );
                  })
                ],),
            ],
          ),
        )
    );
  }


  AppButton get button{
    return AppButton(
      
      child: Text(
        "Upgrade",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
      onPressed: () async {

        await navService.to(AppRoutes.subscriptions);

      },
    );
}

  AppButton get cancelButton{
    return AppButton(
      
      isTextButton: true,
      onPressed: ()async{},

      child: Text(
        "cancel",
        style: GoogleFonts.poppins(fontSize: 16),
      ),
    );
  }
}
