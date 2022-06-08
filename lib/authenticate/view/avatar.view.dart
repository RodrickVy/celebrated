import 'package:bremind/authenticate/interface/auth.controller.interface.dart';
import 'package:bremind/navigation/controller/route.names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AvatarView extends StatelessWidget {
  final IAuthController controller;

  const AvatarView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        // if (controller.isAuthenticated.isFalse) {
        return InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.profile);
          },
          child: controller.user.value.hasAvatar()
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset(
                    controller.user.value.avatar,
                    height: 50,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Text(
                    controller.user.value.isEmpty() &&
                            controller.user.value.userName.isEmpty
                        ? "AN"
                        : controller.user.value.userName
                            .split("")
                            .first
                            .toUpperCase(),
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                ),
        );
      },
    );
  }
}
