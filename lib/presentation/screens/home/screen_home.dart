import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:social_media/application/providers.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/presentation/widgets/custom_appbar_widget.dart';
import 'package:social_media/presentation/widgets/session_one.dart';
import 'package:social_media/presentation/widgets/session_three.dart';
ValueNotifier<bool> scrollNotifier = ValueNotifier(true);

class ScreenHome extends StatefulWidget {
  final String uid = '';
  bool isLoading = true;
  ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    setState(() {
      widget.isLoading = true;
    });
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
    log(FirebaseAuth.instance.currentUser!.displayName.toString());
    setState(() {
      widget.isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: CustomAppBarWidget(
              title: "",
              // actions: [
              //   TextButton(
              //       onPressed: () {
              //         FirebaseAuth.instance
              //             .signOut()
              //             .then((value) => Navigator.pushReplacement(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => const SplashScreen(),
              //                 )));
              //       },
              //       child: const Text('Log Out')),
              // ],
            ),
            backgroundColor: const Color.fromARGB(255, 212, 225, 227),
            body:ValueListenableBuilder(
                valueListenable: scrollNotifier,
                builder: (BuildContext context, index, _) {
                  final UserProvider userProvider =
                      Provider.of<UserProvider>(context);
                  return NotificationListener<UserScrollNotification>(
                      onNotification: ((notification) {
                        final ScrollDirection direction =
                            notification.direction;
                        if (direction == ScrollDirection.reverse) {
                          scrollNotifier.value = false;
                        } else if (direction == ScrollDirection.forward) {
                          scrollNotifier.value = true;
                        }
                        return true;
                      }),
                      child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Stack(children: [
                            ListView(
                                padding: const EdgeInsets.only(top: 90),
                                physics: const BouncingScrollPhysics(),
                                children: const [
                                  //    StoryContainer(),
                                  SessionThree()
                                ]),
                            scrollNotifier.value == true
                                ? SessionOne(
                                    userName: userProvider.getUser.username)
                                : kheight10
                          ])));
                }),
          );
  }
}
