import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';


import 'package:social_media/presentation/widgets/custom_appbar_widget.dart';
import 'package:social_media/presentation/widgets/primary_button_widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: const CustomAppBarWidget(title: "Social.ly",),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
           
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 10,),
            PrimaryButtonWidget(title: "register", onPressed: (){
              _registerUser(emailController.text, passwordController.text);
            })
          ],
        ),
      ),
    );
  }

  Future<void> _selectProfilePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
       
      });
    }
  }

  Future<void> _registerUser(String email, String password, ) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Here, you can upload the profile image to a cloud storage service (e.g., Firebase Storage)
      // and store the image URL in Firestore or a database.

      // After successful registration, you can navigate to the user's profile or other parts of your app.
    } catch (e) {
      // Handle registration errors and display a message to the user.
      // You may want to include error handling for email validation and password strength checks.
    }
  }
}
