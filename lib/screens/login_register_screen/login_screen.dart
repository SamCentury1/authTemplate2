import 'package:auth_template/resources/auth_service.dart';
import 'package:auth_template/screens/login_register_screen/components/login_button.dart';
import 'package:auth_template/screens/login_register_screen/components/login_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key,required this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();

  final passwordController = TextEditingController();

  void signInUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    // showDialog(
    //   context: context, 
    //   builder: (context) {
    //     return const Center(
    //       child: CircularProgressIndicator(),
    //     );
    //   }
    // );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: usernameController.text, 
        password: passwordController.text
      );
      // Navigator.pop(context);


    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      if (e.code == 'invalid-credential') {
        loginFailed(e.code);
      } else if (e.code == 'invalid-email') {
        loginFailed(e.code);
      } else if (e.code == 'channel-error') {
        loginFailed(e.code);
      }
    }
    
    // Navigator.pop(context);
  }



  void loginFailed(String body) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text(body),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 50,),
                Icon(Icons.lock,size: 100,),
                SizedBox(height: 50,),
                Text(
                  "Welcome back!",
                  style: TextStyle(color: Colors.grey[700],fontSize: 24),
                ),
                SizedBox(height: 25,),
                LoginTextField(controller: usernameController, hintText: 'username', obscureText: false,),
                SizedBox(height: 25,),
                LoginTextField(controller: passwordController, hintText: 'password', obscureText: true,),
                SizedBox(height: 10,),
            
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "forgot password?",
                    style: TextStyle(color: Colors.grey[600],fontSize: 16),
                  ),
                ),
            
                SizedBox(height: 20),
                LoginButton(onTap: signInUser, body: "Sign In"),
                SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey.shade400,),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          "or continue with",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 16
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(thickness: 0.5, color: Colors.grey.shade400,),
                      )                      
                    ],
                  )
                ),

                SizedBox(height: 40),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => AuthService().signInWithGoogle(),
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12.0))
                        ),
                        child: Icon(Icons.g_mobiledata, size: 50,),
                      ),
                    ),

                    SizedBox(width: 10,),

                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: Icon(Icons.apple, size: 50,),
                    ),                    
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("not a member?", style: TextStyle(color: Colors.grey.shade400)),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: widget.onTap,
                      child: Text(
                        "register now",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    )

                  ],
                )
            
              ],
            ),
          ),
        ),
      )
    );
  }
}