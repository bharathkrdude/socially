
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/screens/authentication/screen_login.dart';
import 'package:social_media/presentation/screens/profiles/followers/screen_followers.dart';
import 'package:social_media/presentation/screens/profiles/widgets/builder_widgggets.dart';
import 'package:social_media/presentation/screens/profiles/widgets/follow_button.dart';
import 'package:social_media/presentation/screens/profiles/widgets/text_button_widgets.dart';
import 'package:social_media/presentation/widgets/icon_button_widgets.dart';
import 'package:social_media/presentation/widgets/sncack_bar.dart';
import 'package:social_media/services/auth_service.dart';
import 'package:social_media/services/firestore_methods.dart';

class ProfileStackWIdgets extends StatefulWidget {
  final uid;
  final snap;
  bool isLoading = true;
  ProfileStackWIdgets({Key? key, required this.uid, required this.snap})
      : super(key: key);

  @override
  State<ProfileStackWIdgets> createState() => _ProfileStackWIdgetsState();
}

class _ProfileStackWIdgetsState extends State<ProfileStackWIdgets> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  var userSnap1;
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get post length
      var postSnap = await FirebaseFirestore.instance
          .collection('pots')
          .where('uid', isEqualTo: widget.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackbar(context, kblackcolor, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthMethods authMethods = AuthMethods();
    return isLoading == true
        ? const Center(child: CircularProgressIndicator())
        : Stack(children: [
            const SizedBox(
              width: double.infinity,
              height: 250,
              child: Image(
                  fit: BoxFit.cover, image: AssetImage("assets/images/metaverse-concept-collage-design.jpg")),
              //color: Colors.amber,
            ),
            FirebaseAuth.instance.currentUser!.uid == widget.uid
                ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButtonWidgets(
                            icon: const Icon(Icons.settings),
                            ontap1: () {
                             
                            }))
                  ])
                : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IconButtonWidgets(
                            icon: const Icon(Icons.arrow_back),
                            ontap1: () {
                              Get.back();
                            }))
                  ]),
            Center(
                heightFactor: 1.7,
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kprofileContainercolor),
                    width: 400,
                    height: 600,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, left: 20),
                                child: TextFollowersWidgets(
                                    followers: followers.toString(),
                                    name: 'Followers',
                                    click: () {
                                      Get.to(const ScreenFollowers());
                                    })),
                            const Spacer(),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, right: 20),
                                child: TextFollowersWidgets(
                                    followers: following.toString(),
                                    name: 'Following',
                                    click: () {
                                      Get.to(const ScreenFollowers());
                                    }))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('@_${userData['username']}',
                                style: const TextStyle(color: kblackcolor))
                          ]),
                      const SizedBox(height: 10),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            Text(
                                ' ${userData['bio']}',
                                style: const TextStyle(fontSize: 11.5))
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FirebaseAuth.instance.currentUser!.uid == widget.uid
                                ? FollowButton(
                                    backgroundColor: kblackcolor,
                                    borderColor: kwhitecolor,
                                    text: 'LogOut',
                                    textColor: kwhitecolor,
                                    function: () {
                                      authMethods.signOut();

                                      Navigator.of(context).pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginScreen()),
                                          (route) => false);
                                    },
                                  )
                                : isFollowing
                                    ? Row(
                                        children: [
                                          FollowButton(
                                            backgroundColor: kblackcolor,
                                            borderColor: kwhitecolor,
                                            text: 'Unfollow',
                                            textColor: kwhitecolor,
                                            function: () async {
                                              await FireStoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                            },
                                          ),
                                          
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          FollowButton(
                                            backgroundColor: kblackcolor,
                                            borderColor: kwhitecolor,
                                            text: 'Follow',
                                            textColor: kwhitecolor,
                                            function: () async {
                                              await FireStoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          ),
                                          
                                        ],
                                      ),
                          ]),
                      const SizedBox(height: 20),
                      Expanded(
                          child: PostsBuilderWidget(uid: widget.uid.toString()))

                      // bottom:
                    ]))),
            Center(
                heightFactor: 4.25,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(userData['photoUrl'])),
                        border: Border.all(width: 5, color: Colors.white),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black),
                    width: 100,
                    height: 100))
          ]);
  }
} 

// ignore: must_be_immutable

