// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:blog_app_last/screen/home_screen.dart';
import 'package:blog_app_last/screen/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAuth auth=FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    final user=auth.currentUser;
    if(user != null){
      Timer(
          Duration(seconds: 3),
              ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen(),)));
    }else{
      Timer(
          Duration(seconds: 3),
              ()=>Navigator.push(context, MaterialPageRoute(builder: (context) => OptionScreen(),)));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              image: AssetImage('images/splash.jpg'),
            ),
               SizedBox(height: 10,),  
             Align(
                alignment: Alignment.center,
                child: Text(
                  'Blog',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 30,
                      fontWeight: FontWeight.w300),
                ),
              ),
            

          ],
        ),
      ),
    );
  }
}
