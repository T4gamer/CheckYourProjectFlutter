import 'package:gradefy/models/new_token.dart';
import 'package:gradefy/services/endpoints.dart';
import 'package:gradefy/services/internet_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/refreshed_token.dart';

Future<bool> login(String username, String password) async {
  final InternetService services = InternetService();
  if (services.isAuthorized()) {
    return true;
  } else {
    final tokenBody = await services
        .post(CREATETOKEN, {"username": username, "password": password});
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      final token = newTokenFromJson(tokenBody.body);
      await prefs.setString("refresh", token.refresh);
      services.setToken(token.access);
      return true;
    } catch (e) {
      return false;
    }
  }
}

Future<bool> refreshLoginService() async {
  final InternetService services = InternetService();
  if (!services.isAuthorized()) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? storedToken = prefs.getString("refresh");
    try {
      final token =
          await services.post(REFRESHTOKEN, {"refresh": "$storedToken"});
      services.setToken(refreshedTokenFromJson(token.body).access);
      return true;
    } catch (e) {
      return false;
    }
  } else {
    return true;
  }
}

Future<void> logout() async {
  final InternetService services = InternetService();
  services.removeToken();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove("refresh");
}
