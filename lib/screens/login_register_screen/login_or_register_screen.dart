import 'package:auth_template/screens/login_register_screen/components/login_button.dart';
import 'package:auth_template/screens/login_register_screen/components/login_textfield.dart';
import 'package:auth_template/screens/login_register_screen/login_screen.dart';
import 'package:auth_template/screens/login_register_screen/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginOrRegisterScreen extends StatefulWidget {
  LoginOrRegisterScreen({super.key});

  @override
  State<LoginOrRegisterScreen> createState() => _LoginOrRegisterScreenState();
}

class _LoginOrRegisterScreenState extends State<LoginOrRegisterScreen> {

  late bool showLoginScreen = true;

  void toggleScreens() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginScreen) {
      return LoginScreen(onTap: toggleScreens,);
    } else {
      return RegisterScreen(onTap: toggleScreens,);
    }
  }
}