import 'package:bremind/navigation/controller/nav.controller.dart';
import 'package:bremind/navigation/views/app.bar.dart';
import 'package:bremind/navigation/views/app.bottom.nav.bar.dart';
import 'package:bremind/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

abstract class AppView<T> extends StatelessWidget{
  final  T controller = Get.find<T>();

  

   AppView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
   return SafeArea(
     child: Scaffold(
       appBar: const AppTopBar(),
       body: view(ctx: context, adapter: Adaptives(context)),
       bottomNavigationBar: AppBottomNavBar<NavController>(),

     ),
   );
  }
  
  
  
  Widget view({required BuildContext ctx,required Adaptives adapter});
  
}