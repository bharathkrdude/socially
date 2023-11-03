

import 'package:flutter/cupertino.dart';
import 'package:social_media/domain/models/user_model.dart';
import 'package:social_media/services/auth_service.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();
  UserModel get getUser => _user!;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
