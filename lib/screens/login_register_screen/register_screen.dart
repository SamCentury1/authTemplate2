import 'package:auth_template/resources/auth_service.dart';
import 'package:auth_template/screens/login_register_screen/components/login_button.dart';
import 'package:auth_template/screens/login_register_screen/components/login_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, required this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final password1Controller = TextEditingController();
  final password2Controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void registerUser() async {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      List<String> errors = [];
      if (password1Controller.text != password2Controller.text) {
        errors.add("passwords don't match");
      }

      if (password1Controller.text.length <= 6) {
        errors.add("passowrd must be over 6 characters");        
      }

      if (errors.isEmpty) {

        // await AuthService().registerUser(usernameController.text, password1Controller.text);
        UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: usernameController.text.trim(), 
          password: password1Controller.text.trim(),
        );
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "uid": cred.user!.uid,
          "username": "",
          "email": usernameController.text.trim(),
          "createdAt": DateTime.now().toIso8601String(),
        });         

      } else {
        registrationError(errors);
      }

    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        authError(e.code);
      } else if (e.code == 'invalid-email') {
        authError(e.code);
      } else if (e.code == 'channel-error') {
        authError(e.code);
      }
    }
  }


  void authError(String error) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(error),
        );
      }
    );
  }

  void registrationError(List<String> body) {
    showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Column(
            children: [
              for (String item in body)
              Text(item)
            ]
          ),
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
                  "Welcome!",
                  style: TextStyle(color: Colors.grey[700],fontSize: 24),
                ),
                SizedBox(height: 25,),
                LoginTextField(controller: usernameController, hintText: 'Username', obscureText: false,),
                SizedBox(height: 25,),
                LoginTextField(controller: password1Controller, hintText: 'Password', obscureText: true,),
                SizedBox(height: 25,),
                LoginTextField(controller: password2Controller, hintText: 'Confirm Password', obscureText: true,),

            
                SizedBox(height: 20),
                LoginButton(onTap: registerUser, body: "Register"),
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
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12.0))
                      ),
                      child: Icon(Icons.g_mobiledata, size: 50,),
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
                    Text("already a member?", style: TextStyle(color: Colors.grey.shade400)),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: widget.onTap,
                      child: Text(
                        "login now",
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