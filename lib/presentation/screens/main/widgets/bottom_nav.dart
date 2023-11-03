import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/presentation/screens/home/screen_home.dart';
import 'package:social_media/presentation/screens/newposts/screen_new_posts.dart';
import 'package:social_media/presentation/screens/profile/screen_profile.dart';

class BottomNavigationWidget extends StatefulWidget {
  String currentUserUid = FirebaseAuth.instance.currentUser!.uid;

   BottomNavigationWidget({super.key});

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
      ScreenHome(),
    //  const ScreenSearch(),
    //  const ScreenAddPost(),
     const NewPostsScreen(),
      const ScreenProfile()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        useLegacyColorScheme: true,
        elevation: 2,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        unselectedItemColor: textColor,
        unselectedIconTheme: const IconThemeData(color: textColor),
        backgroundColor: const Color.fromARGB(255, 173, 185, 186),
        type: BottomNavigationBarType.fixed,
        fixedColor: textColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search),
          //   label: 'search',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add_to_photos,),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_sharp,size: 32,color: Colors.black87,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
