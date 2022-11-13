import 'package:celebrated/app.swatch.dart';
import 'package:celebrated/authenticate/controller/auth.controller.dart';
import 'package:celebrated/authenticate/view/avatar.view.dart';
import 'package:celebrated/domain/view/app.state.view.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/interface/controller.interface.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDesktopDrawer<NAV extends INavController> extends AppStateView<NAV> {
  final AuthController authController = Get.find<AuthController>();

  AppDesktopDrawer({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(
          () =>
          AnimatedContainer(
            width: controller.drawerExpanded ? 280 : 70,
            height: adapter.height,
            duration: const Duration(milliseconds: 400),
            child: Drawer(
                elevation: 0,
                backgroundColor: AppSwatch.primaryAccent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(alignment:Alignment.topCenter,child: AvatarView(radius:controller.drawerExpanded ?90:80 ,)),
                    Obx(
                          () =>
                          Padding(
                              padding: const EdgeInsets.all(6),
                              child: Text(
                               controller.drawerExpanded ? authController.user.value.userName: authController.user.value.userInitials,
                                style: GoogleFonts.mavenPro(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              )),
                    ),
                    ...controller.items.map((AppPage item) {
                      return  controller.drawerExpanded
                          ? OpenDrawerItem(controller: controller, item: item,)
                          : ClosedDrawerItem(item: item, controller: controller);
                    }).toList(),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [IconButton(onPressed: () {
                        controller.toggleDrawerExpansion();
                      }, icon: Icon(controller.drawerExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios))
                      ],
                    ),
                  ],
                )),
          ),
    );
  }
}

class OpenDrawerItem extends StatelessWidget {
  const OpenDrawerItem({
    Key? key,
    required this.item,
    required this.controller,
  }) : super(key: key);

  final AppPage item;
  final INavController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
      child: ListTile(
        leading: Icon(item.icon),
        visualDensity: VisualDensity.compact,
        // selectedColor:controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54
        selectedTileColor: AppSwatch.primary.shade500.withAlpha(34),
        title: Text(
          item.name,
          style: GoogleFonts.poppins(fontSize: 18),
        ),
        tileColor: Colors.transparent,
        selected: controller.currentItem.toLowerCase() == item.route,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onTap: () {
          NavController.instance.to(item.route);
        },
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}

class ClosedDrawerItem extends StatelessWidget {
  const ClosedDrawerItem({
    Key? key,
    required this.item,
    required this.controller,
  }) : super(key: key);

  final AppPage item;
  final INavController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        // selectedColor:controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54
        selectedTileColor: AppSwatch.primary.shade500.withAlpha(34),
        title: Icon(item.icon),
        tileColor: Colors.transparent,
        selected: controller.currentItem.toLowerCase() == item.route,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        onTap: () {
          NavController.instance.to(item.route);
        },
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}