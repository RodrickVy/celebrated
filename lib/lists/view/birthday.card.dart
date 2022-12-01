
import 'package:celebrated/lists/model/birthday.dart';
import 'package:celebrated/domain/view/interface/adaptive.ui.dart';
import 'package:celebrated/util/adaptive.dart';
import 'package:celebrated/util/date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthdayCard2ViewOnly extends AdaptiveUI {
  final ABirthday birthday;
  final double? width;
  final double? height;
  final VoidCallback? onSelect;

  const BirthdayCard2ViewOnly(
      {Key? key,
      this.width = 160,
      this.height = 280,
        this.onSelect,
      required this.birthday,
      })
      : super(key: key);

  @override
  Widget view({required BuildContext ctx, required Adaptive adapter}) {
     return Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: SizedBox(
            width: width,
            height: height,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                width: Get.width,
                decoration: const BoxDecoration(
                    color: Colors.black,
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white12,
                          Colors.white24
                        ])),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        birthday.date.monthInShortForm,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w200,
                            fontSize: 17)),
                    Text(birthday.date.day.toString(),
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 40)),
                    FittedBox(
                      child: Text(birthday.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ),
                    Text(birthday.formattedBirthday(ctx)),
                  ],
                ),
              ),
            ),
          ));
     
  }
}
