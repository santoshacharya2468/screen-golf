import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/screens/nav_screen.dart';
import 'package:massageapp/screens/screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    
    super.initState();
    _splashControl();
  }
   _splashControl()async{
     final user=FirebaseAuth.instance.currentUser;
     String redirectUrl=LoginScreen.routeName;
     if(user!=null){
       redirectUrl=NavigationScreen.routeName;
     }
   await  Future.delayed(Duration(seconds: 2));
   Navigator.of(context).pushReplacementNamed(redirectUrl);
   }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset('assets/splash.jpeg',
       height: MediaQuery.of(context).size.height,
       width: MediaQuery.of(context).size.width,
       //fit: BoxFit.fitHeight,
      ),
    );
  }
}