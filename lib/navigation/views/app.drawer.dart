import 'package:celebrated/app.theme.dart';
import 'package:celebrated/authenticate/view/components/user.avatar.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/navigation/controller/nav.controller.dart';
import 'package:celebrated/navigation/model/route.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDesktopDrawer extends AdaptiveUI {
  const AppDesktopDrawer({Key? key}) : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
    return Obx(() {
      navService.currentItemIndex;

      return AnimatedContainer(
        width: navService.drawerExpanded ? 280 : 70,
        height: adapter.height,
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(border: Border(right: AppTheme.shape.side)),
        child: Drawer(
            elevation: 0,
            backgroundColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: AvatarView(
                      radius: navService.drawerExpanded ? 90 : 80,
                    )),
                ...navService.items.map((AppPage item) {
                  return navService.drawerExpanded ? OpenDrawerItem(item: item) : ClosedDrawerItem(item: item);
                }).toList(),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          navService.toggleDrawerExpansion();
                        },
                        icon: Icon(navService.drawerExpanded ? Icons.arrow_back_ios : Icons.arrow_forward_ios))
                  ],
                ),
              ],
            )),
      );
    });
  }
}

class OpenDrawerItem extends StatelessWidget {
  OpenDrawerItem({
    Key? key,
    required this.item,
  }) : super(key: key) {
    Future.delayed(const Duration(seconds: 1), () {
      show(true);
    });
  }

  final AppPage item;
  final RxBool show = false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AnimatedOpacity(
        opacity: show.value ? 1 : 0.4,
        duration: const Duration(seconds: 1),
        child: Padding(
          padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
          child: ListTile(
            leading: Icon(item.icon),
            visualDensity: VisualDensity.compact,
            // selectedColor:controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54
            selectedTileColor: Colors.transparent,
            title: Text(
              item.name,
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            tileColor: Colors.transparent,
            selected: navService.items[navService.currentItemIndex] == item,
            shape: AppTheme.shape.copyWith(side: BorderSide.none),
            onTap: () {
             navService.to(item.route);
            },
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ),
    );
  }
}

class ClosedDrawerItem extends StatelessWidget {
  const ClosedDrawerItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final AppPage item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0).copyWith(bottom: 0, top: 5),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        // selectedColor:controller.currentItemIndex == index ? AppSwatch.primary.shade500:Colors.black54
        selectedTileColor: Colors.transparent,
        // AppSwatch.primary.shade500.withAlpha(34),
        title: Icon(item.icon),
        tileColor: Colors.transparent,
        selected: navService.items[navService.currentItemIndex] == item,
        shape: AppTheme.shape.copyWith(side: BorderSide.none),
        onTap: () {
         navService.to(item.route);
        },
        contentPadding: const EdgeInsets.all(12),
      ),
    );
  }
}
