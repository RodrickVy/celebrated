import 'package:flutter/material.dart';

class AppTopBar extends PreferredSize {

  const AppTopBar({Key? key}) : super(key: key,
    preferredSize: const Size.fromHeight(65),
    child: const SizedBox(),
  );

  @override
  Widget build(BuildContext context) {
    return AppBar(
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(12),
        //     side: BorderSide.none
        // ),
      elevation: 0.4,
        title: const Text("breminder  "),
    );
  }


}