import 'package:flutter/material.dart';
import 'package:timetable_viewer/handlers/token_handler.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocusNode = FocusNode();
  String errorText = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: _usernameController,
            onSubmitted: (String str) {
              _passwordFocusNode.requestFocus();
            },
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Username",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          TextField(
            controller: _passwordController,
            focusNode: _passwordFocusNode,
            onSubmitted: (String str) async {
              String usernameText = _usernameController.text;
              String passwordText = str;
              List result =
                  await TokenHandler.getToken(usernameText, passwordText);
              if (result[0] == "Error") {
                setState(() {
                  errorText = result[1];
                });
                return;
              }
              await TokenHandler.storeToken();
              if (!mounted) return;
              Navigator.pop(context);
            },
            obscureText: true,
            style: const TextStyle(
              color: Colors.black,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Password",
              hintStyle: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Text(errorText),
        ],
      ),
    );
  }
}
