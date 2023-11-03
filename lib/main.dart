import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:social_media/application/providers.dart';
import 'package:social_media/firebase_options.dart';
import 'package:social_media/presentation/screens/spalsh/spalsh_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const Socially());
}

class Socially extends StatelessWidget {
  const Socially({super.key});

  
  @override
   Widget build(BuildContext context) {
    return MultiProvider(
      providers: [          ChangeNotifierProvider(create: (_) => UserProvider()),
],
      child: GetMaterialApp (
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          
          primaryColor: const Color.fromARGB(255, 224, 232, 224),
          brightness: Brightness.light,
        ),
    
        home: const SplashScreen(),
      ),
    );
  }
}

