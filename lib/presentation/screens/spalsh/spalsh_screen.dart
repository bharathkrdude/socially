import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/screens/spalsh/state_checking_widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
Future gotohome() async {
    await Future.delayed(const Duration(seconds: 2));

    Get.offAll(() => const StateCheckingWidget(),
        transition: Transition.circularReveal,
        duration: const Duration(seconds: 1));
  }

  @override


  @override
  Widget build(BuildContext context) {
     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      gotohome();
    });
    return Scaffold(
      backgroundColor: splashColor,
      body: Center(
          child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 48,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "assets/images/watersplash.png",
            scale: 4.0,
          ),
        ),
      )),
    );
  }
}
