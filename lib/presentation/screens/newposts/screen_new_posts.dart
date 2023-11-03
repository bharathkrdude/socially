// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:social_media/application/providers.dart';
import 'package:social_media/core/colors.dart';
import 'package:social_media/core/constants.dart';
import 'package:social_media/services/firestore_methods.dart';
import 'package:social_media/utils/utils.dart';


class NewPostsScreen extends StatefulWidget {
  const NewPostsScreen({Key? key}) : super(key: key);

  @override
  State<NewPostsScreen> createState() => _NewPostsScreenState();
}

class _NewPostsScreenState extends State<NewPostsScreen> {
  Uint8List? _file;
  bool isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();
  void addPost(String uid, String username, String profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
      );
      if (res == "success") {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  void initState() {
    addData();
    super.initState();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kwhitecolor,
            elevation: 0,
            toolbarHeight: 80,
            centerTitle: true,
            title: const Text('Create a Post',
                style: TextStyle(color: kblackcolor)),
            actions: [
              IconButton(
                  onPressed: () {
                    addPost(
                        userProvider.getUser.uid,
                        userProvider.getUser.username,
                        userProvider.getUser.photoUrl);
                  },
                  icon: const Icon(Icons.post_add, color: kblackcolor))
            ]),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: kblackcolor,
                        backgroundImage: NetworkImage(
                            userProvider.getUser.photoUrl.toString()),
                      ),
                      kwidth10,
                      Text(
                        userProvider.getUser.username,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  kheight20,
                  _file == null
                      ? const Center(
                          child: Text('Post some'),
                        )
                      : imageContainer(_file, context),
                  TextField(
                      controller: _descriptionController,
                      decoration:
                          const InputDecoration(hintText: 'New post....')),
                  ListTile(
                      leading: const Icon(Icons.photo),
                      title: const Text('Add A Phooto'),
                      onTap: () async {
                        Uint8List file = await pickImage(ImageSource.gallery);
                        setState(() {
                          _file = file;
                        });
                      }),
                  
                ],
              ));
  }

  Container imageContainer(imageLink, context) {
    return Container(
        height: 500,
        width: 100,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill, image: MemoryImage(imageLink!))));
  }
}
