
// ignore_for_file: prefer_const_constructors

import 'package:blog_app_last/componant/round_buttom.dart';
import 'package:blog_app_last/screen/forget_password_screen.dart';
import 'package:blog_app_last/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  String email='' ,password='';
  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backwardsCompatibility: false,
        ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Login',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 33.0),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
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
                            decoration: const InputDecoration(
                              hintText: 'password',
                              labelText:'password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(),
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
                        Padding(
                          padding: const EdgeInsets.only(top: 10,bottom: 30),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ForgetPasswordScreen()));
                            },
                            child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text('Forgot password ?')),
                          ),
                        ),
                        RoundButtton(title: 'Login', onPress: ()async{
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              showSpinner=true;
                            });
                            try{
                              final user = await _auth.signInWithEmailAndPassword(
                                email: email.toString().trim(),
                                password: password.toString().trim(),
                              );
                              // ignore: unnecessary_null_comparison
                              if(user != null){
                                toastMethod('user successfully login');
                                setState(() {
                                  showSpinner=false;
                                });
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
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

        ) ,
      ),
    );
  }
  void toastMethod(String message){
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black45,
        fontSize: 16.0
    );
  }
}
