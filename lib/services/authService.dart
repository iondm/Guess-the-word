import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sofia/components/error/http_exception.dart';
import 'package:sofia/database/levelDB.dart';

class AuthService with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        token != null) return _token!;
    return null;
  }

  Future<void> auth(String email, String password, String mode) async {
    var prefs = await SharedPreferences.getInstance();
    Uri url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:${mode}?key=AIzaSyCOooy-iOgt5gq54X9po8X8qHC5FluT29s");

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {"email": email, "password": password, "returnSecureToken": true},
        ),
      );
      var respData = await json.decode(response.body);
      if (respData["error"] != null) {
        print("\trespData error: ${respData["error"]}");
        throw HttpException(respData["error"]["message"]);
      }

      _token = respData["idToken"];
      _userId = respData["localId"];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(respData["expiresIn"])));

      if (mode == "signUp") {
        saveInServer(
            email: email,
            id: respData["localId"],
            tempId: prefs.getString("tempUserId")!);
      }

      if (mode == "signInWithPassword" && _userId != null) {
        String res = await loginFromServer(id: _userId!);
        if (res != "ok") throw HttpException("server error");
      }
      prefs.setString("token", respData["idToken"]);
      prefs.setString("userId", respData["localId"]);
      prefs.setString(
          "tokenExpire",
          DateTime.now()
              .add(Duration(seconds: int.parse(respData["expiresIn"])))
              .toIso8601String());
    } catch (error) {
      print("\t catch error: $error");
      throw error;
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    return auth(email, password, "signUp");
  }

  Future<void> signIn({required String email, required String password}) async {
    return auth(email, password, "signInWithPassword");
  }

  static Future<String> saveInServer(
      {required String email,
      required String id,
      required String tempId}) async {
    var prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse(
        "http://35.180.201.46:8080/user/sign-in?email=$email&id=$id&tempId=$tempId");
    print("user/sign-in result:");
    print(url.toString());
    try {
      var result = await http.get(url);
      var resultData = await json.decode(result.body);
      print(resultData);
      if (resultData.error != null) {
        prefs.setBool("userInDb", true);
        updateDataToServer();
        return "ok";
      } else
        return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  static Future<String> loginFromServer({required String id}) async {
    var prefs = await SharedPreferences.getInstance();

    Uri url = Uri.parse("http://35.180.201.46:8080/user/login?id=$id");
    print("user/login result:");
    print(url.toString());
    try {
      var result = await http.get(url);
      var resultData = await json.decode(result.body);
      print(resultData);
      if (!resultData.containsKey("error")) {
        if (!resultData.containsKey("currentLevel") ||
            !resultData.containsKey("lastWord") ||
            !resultData.containsKey("points")) return "error";
        prefs.setInt("currentLevel", int.parse(resultData["currentLevel"]));
        prefs.setString("lastWord", resultData["lastWord"].toString());
        prefs.setInt("points", int.parse(resultData["points"]));
        prefs.setString("userId", id);
        print("lastWord = ${resultData["lastWord"].toString()}");
        return LevelDB.initNewLoginData(int.parse(resultData["currentLevel"]));
      } else
        return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }

  static Future<String> updateDataToServer() async {
    print("updateDataToServer");
    var prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString("userId");
    print(userId);
    if (userId == null) return "error";
    int points = prefs.getInt("points")!;
    int currentLevel = prefs.getInt("currentLevel")!;
    String lastWord = prefs.getString("lastWord")!;

    Uri url = Uri.parse(
        "http://35.180.201.46:8080/user/update?userId=$userId&points=$points&current_level=$currentLevel&last_word=$lastWord");
    print("user/update result:");
    print(url.toString());
    try {
      var result = await http.get(url);
      var resultData = await json.decode(result.body);
      print(resultData);
      if (resultData.error != null) {
        return "ok";
      } else
        return "error";
    } catch (e) {
      print(e);
      return "error";
    }
  }
}
