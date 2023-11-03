import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/presentation/screens/profiles/widgets/show_diloge_posts.dart';

class ScreenProfile extends StatelessWidget {
  const ScreenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    String currentUserUID = FirebaseAuth.instance.currentUser!.uid;

    return SingleChildScrollView(
      child: ProfileStackWIdgets(
        uid: currentUserUID,
        snap: null,
      ),
    );

    // return   const SafeArea(
    //   child:  Scaffold(
    //     appBar: CustomAppBarWidget(title: "", ),
    //     body: SingleChildScrollView(
    //       scrollDirection: Axis.vertical,
    //       child: Column(

    //         children: [
    //           SizedBox(height: 20,),
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               CircleAvatar(
    //                 radius: 60,
    //                 child:ClipRRect(

    //                 ),

    //               ),

    //             ],

    //           ),
    //           SizedBox(height:10),
    //           Text("@User Name"),
    //           Row(
    //             children: [
    //               SizedBox(

    //               )
    //             ],
    //           )
    //         ],
    //       ),
    //     )
    //   ),
  }
}
