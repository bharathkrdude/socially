import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/screens/search/screen_search.dart';
import 'package:social_media/presentation/widgets/icon_button_widgets.dart';


// ignore: must_be_immutable
class SessionOne extends StatefulWidget {
  String userName = '';
  SessionOne({Key? key, required this.userName}) : super(key: key);

  @override
  State<SessionOne> createState() => _SessionOneState();
}

class _SessionOneState extends State<SessionOne> {
  @override
  Widget build(BuildContext context) {
    //  AuthMethods authService = AuthMethods();
    return AnimatedContainer(
      duration: const Duration(microseconds: 1000),
      width: double.infinity,
      height: 90,
      color: kwhitecolor,
      // color: kblackcolor,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButtonWidgets(
                icon: const Icon(Icons.camera_alt), ontap1: () {}),
          ),
          const Spacer(),
          Text("@_${widget.userName}",
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(10),
            child: IconButtonWidgets(
                icon: const Icon(Icons.search),
                ontap1: () {
                  Get.to(const ScreenSearch());
                }),
          )
        ],
      ),
    );
  }
}
