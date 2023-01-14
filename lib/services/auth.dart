// ignore_for_file: unused_field, unnecessary_this, non_constant_identifier_names, avoid_print

// ignore: library_prefixes
import 'package:dio/dio.dart' as Dio;
import 'package:fire_app/models/user.dart';
import 'package:fire_app/services/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Auth extends ChangeNotifier {
  bool _isloggedIn = false;
  late User _user;
  late String _token;
  bool get authenticated => _isloggedIn;
  User get user => _user;
  void Login(Map creds) async {
    print(creds);
    try {
      Dio.Response response = await dio().post('/sanctum/token', data: creds);
      print(response.data.toString());
      String token = response.data.toString();
      this.tryToken(token: token);
    } catch (e) {
      print(e);
    }
  }

  void tryToken({required String token}) async {
    if (token == null) {
      return;
    } else {
      try {
        Dio.Response response = await dio().get('/user',
            options: Dio.Options(headers: {'Authorization': 'Bearer $token '}));
        this._isloggedIn = true;
        this._user = User.fromJson(response.data);
        notifyListeners();
        print(_user);
      } catch (e) {
        print(e);
      }
    }
  }

  void Logout() {
    _isloggedIn = false;
    notifyListeners();
  }
}
