

import 'package:flutter/material.dart';
import 'package:social_media/presentation/screens/main/widgets/bottom_nav.dart';

class ScreenMain extends StatelessWidget {
   const ScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return    SafeArea(
      child:  Scaffold(
        bottomNavigationBar: BottomNavigationWidget(),
      ),
    );
  }
}