import "package:http/http.dart" as http;
import "dart:convert";
import 'package:shared_preferences/shared_preferences.dart';

class TokenHandler {
  static final TokenHandler _tokenHandler =
      TokenHandler._tokenHandlerConstructor();
  static String loginToken = "";
  static Future<String?> loadCachedToken() async {
    await TokenHandler.loadToken();
    String currentToken = TokenHandler.loginToken;
    if (currentToken == "") {
      return null;
    }
    return loginToken;
  }

  static Future<void> storeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("loginToken", loginToken);
  }

  static Future<void> loadToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? str = prefs.getString("loginToken");
    if (str != null) {
      loginToken = str;
    }
  }

  static Future<List<dynamic>> getToken(
      String username, String password) async {
    final body = {"txtLoginId": username, "txtPassword": password};
    final res = await http.post(
      Uri.parse("https://www.hartismere.com/_api/account/login"),
      body: body,
    );
    Map decodedBody = jsonDecode(res.body);
    if (decodedBody["success"] == false) {
      return ["Error", decodedBody["error"]];
    } else if (res.statusCode == 200) {
      final String token = decodedBody["cv"];
      loginToken = token;
      return ["Success"];
    }
    return ([]);
  }

  factory TokenHandler() {
    return _tokenHandler;
  }
  TokenHandler._tokenHandlerConstructor();
}
