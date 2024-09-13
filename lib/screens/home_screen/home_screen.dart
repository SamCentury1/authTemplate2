import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  late User? currentUser;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {

    print(FirebaseAuth.instance.currentUser);
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(
            onPressed: signOut, 
            icon: Icon(Icons.logout)
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  // color: Colors.red,
                  child: Text(
                    "Profile",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 39, 39, 39),
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Divider(height: 2,color: const Color.fromARGB(255, 211, 210, 210),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: const Color.fromARGB(255, 226, 225, 225),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                // color: Colors.blue,
                                child: ClipOval(
                                  clipper: ProfilePictureClipper(),
                                  child: Image.network(currentUser!.photoURL!),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  // color: Color.fromARGB(255, 206, 205, 205),
                                  borderRadius: BorderRadius.all(Radius.circular(6.0))
                                ),
                      
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(12.0,2.0,12.0,2.0),
                                  child: Text(
                                    currentUser!.displayName!,
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 2.0, color: Colors.grey,),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Icon(Icons.email, size: 28,),
                              SizedBox(width: 20,),
                              Text(
                                currentUser!.email!,
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              )
                            ],
                          )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          child: Row(
                            children: [
                              Icon(Icons.phone, size: 28,),
                              SizedBox(width: 20,),
                              Text(
                                currentUser!.phoneNumber ?? "-",
                                style: TextStyle(
                                  fontSize: 18
                                ),
                              )
                            ],
                          )
                        ),
                      )                      
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePictureClipper extends CustomClipper<Rect> {
  Rect getClip(Size size) {
    return Rect.fromCenter(center: Offset(size.width/2,size.height/2), width: size.width, height: size.height);
  }
  bool shouldReclip(oldClipper) {
    return false;
  }
}