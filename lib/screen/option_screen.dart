import 'package:blog_app_last/componant/round_buttom.dart';
import 'package:blog_app_last/screen/login_screen.dart';
import 'package:blog_app_last/screen/signin.dart';
import 'package:flutter/material.dart';
class OptionScreen extends StatefulWidget {
  const OptionScreen({Key? key}) : super(key: key);

  @override
  _OptionScreenState createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Image(image:  AssetImage('images/logo.jpg'),),
              const SizedBox(height: 30,),
              RoundButtton(title: 'Login', onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
              }),
              const SizedBox(height: 30,),
              RoundButtton(title: 'Register', onPress: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignIn()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
