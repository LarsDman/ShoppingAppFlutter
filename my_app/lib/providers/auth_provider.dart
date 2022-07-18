import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:my_app/constants/constants.dart' as constants;
import "dart:convert";

import 'package:my_app/models/custom_exception.dart';
import 'package:my_app/screens/login_screen.dart';
import 'package:my_app/constants/constantsLinks.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String _token = "";
  DateTime _expiryDate = DateTime.now();
  String _userId = "";
  String _name = "";
  bool _autologin = false;

  bool get isAuth {
    return token != "";
  }

  String get name {
    return _name;
  }

  bool get autologin {
    return _autologin;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return "";
  }

  Future<void> _server(
      String email, String password, String urlPart, LogingState mode) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlPart?key=$urlKey");
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            constants.email: email,
            constants.password: password,
            constants.returnSecureToken: true,
          },
        ),
      );

      final responseData = json.decode(response.body);
      if (responseData[constants.error] != null) {
        throw CustomException(responseData[constants.error][constants.message]);
      }
      _token = responseData[constants.idToken];
      _userId = responseData[constants.localId];
      _name = mode == LogingState.login
          ? responseData[constants.displayName]
          : responseData[constants.email];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData[constants.expiresIn]),
        ),
      );
      _autologin = true;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> change(String email, String password, String name) async {
    return _editUserName(email, password, name);
  }

  Future<void> networking(
      String email, String password, String name, LogingState mode) async {
    if (mode == LogingState.login) {
      await _server(email, password, constants.signInWithPassword, mode);
      setLoginData();
    } else if (mode == LogingState.signup) {
      await _server(email, password, constants.signUp, mode);
      await _editUserName(email, password, name);
      setLoginData();
    }
  }

  Future<void> _editUserName(String email, String password, String name) async {
    try {
      final url = Uri.parse(
          "https://identitytoolkit.googleapis.com/v1/accounts:update?key=$urlKey");
      final response2 = await http.post(
        url,
        body: json.encode(
          {
            constants.idToken: token,
            constants.displayName: name,
            constants.returnSecureToken: true,
          },
        ),
      );

      final responseData = json.decode(response2.body);
      _name = responseData[constants.displayName];
    } catch (error) {
      rethrow;
    }
  }

  void setLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode({
      constants.token: _token,
      constants.expiryDate: _expiryDate.toIso8601String(),
      constants.userId: _userId,
      constants.userName: _name,
      constants.autologin: true,
    });
    prefs.setString(constants.key, userData);
    notifyListeners();
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(constants.key)) {
      return false;
    }
    if (prefs.getString(constants.key) != null) {
      final extractedData =
          json.decode(prefs.getString(constants.key)!) as Map<String, dynamic>;
      if (extractedData[constants.expiryDate].runtimeType == String) {
        final expiryDate =
            DateTime.parse(extractedData[constants.expiryDate] as String);
        if (expiryDate.isBefore(DateTime.now())) {
          false;
        }
        _token = extractedData[constants.token] as String;
        _expiryDate =
            DateTime.parse(extractedData[constants.expiryDate] as String);
        _userId = extractedData[constants.userId] as String;
        _name = extractedData[constants.userName] as String;
        _autologin = extractedData[constants.autologin] as bool;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  Future<void> logout() async {
    _token = "";
    _userId = "";
    _expiryDate = DateTime.now();
    _autologin = false;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(constants.key);
  }

  void changeAutoLogin(bool value) async {
    _autologin = value;
    if (value) {
      setLoginData();
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.remove(constants.key);
    }
    notifyListeners();
  }
}
