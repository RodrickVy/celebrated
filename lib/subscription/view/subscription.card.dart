import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/app.theme.dart';
import 'package:celebrated/domain/services/ui.forms.state/ui.form.state.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/subscription/models/subscription.dart';
import 'package:celebrated/subscription/models/subscription.plan.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubscriptionCard extends AdaptiveUI {
  final Subscription subscription;
  const SubscriptionCard({
    Key? key, required this.subscription,
  }) : super(key: key);



  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
        ()=> Card(
          shape:  UIFormState.subscriptionPlan.value == subscription.id
              ? AppTheme.shape
              .copyWith(side:  BorderSide(width: 4,style: BorderStyle.solid, color:AppSwatch.primary.shade600))
              : AppTheme.shape,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                if(subscription.id != SubscriptionPlan.test)
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: const Text(" - Currently unavailable -"),
                  ),
                Text(subscription.name,style: adapter.textTheme.headlineSmall, ),
                Text("\$${subscription.price}/mo",style: adapter.textTheme.bodyLarge, ),
                Text(subscription.description,style: adapter.textTheme.bodyMedium, ),
                const SizedBox(height: 30,),
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
                  ],)
              ],
            ),
          )
      ),
    );
  }
}
