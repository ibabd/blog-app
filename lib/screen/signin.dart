// ignore_for_file: prefer_final_fields

import 'package:blog_app_last/componant/round_buttom.dart';
import 'package:blog_app_last/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  String email='' ,password='';
  bool showSpinner=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ignore: prefer_const_constructors
        title: Text('CreateAccount'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ignore: prefer_const_constructors
              Text('Register',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 33.0),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          hintText: 'Email',
                          labelText: 'Email',
                          // ignore: prefer_const_constructors
                          prefixIcon: Icon(Icons.email),
                        ),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String value){
                          email=value;
                        },
                        validator: (value){
                          return value!.isEmpty ?'enter email':null ;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: TextFormField(
                          obscureText: true,
                          // ignore: prefer_const_constructors
                          decoration: InputDecoration(
                            hintText: 'password',
                            labelText:'password',
                            // ignore: prefer_const_constructors
                            prefixIcon: Icon(Icons.lock),
                            border: const OutlineInputBorder(),
                          ),
                          controller: passwordController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String value){
                            password=value;
                          },
                          validator: (value){
                            return value!.isEmpty ?'enter password':null ;
                          },
                        ),
                      ),
                      RoundButtton(title: 'Register', onPress: ()async{
                        if(_formKey.currentState!.validate()){
                          setState(() {
                            showSpinner=true;
                          });
                          try{
                            final user = await _auth.createUserWithEmailAndPassword(
                              email: email.toString().trim(),
                              password: password.toString().trim(),
                            );
                            // ignore: unnecessary_null_comparison
                            if(user != null){
                              toastMethod('user successfully created');
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
                              setState(() {
                                showSpinner=false;
                              });
                            }
                          }catch(e){
                            toastMethod(e.toString());
                            setState(() {
                              showSpinner=false;
                            });
                          }
                        }
                      }),

                    ],
                  ),
                ),
              ),




            ],

          ),
        ),
      ),
    );
  }
  void toastMethod(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
