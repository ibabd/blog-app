// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:blog_app_last/componant/round_buttom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Forgot password'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Login', style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 33.0),),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                          ),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (String value) {
                            email = value;
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'enter email' : null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: RoundButtton(title: 'Recover password', onPress: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                showSpinner = true;
                              });
                              try {
                                _auth.sendPasswordResetEmail(email: emailController.text.toString()).then((value) {
                                  setState(() {
                                    showSpinner = false;
                                  });
                                  toastMethod('please check your email a reset link has been sent to you via email');
                                }).onError((error, stackTrace) {
                                  setState(() {
                                    showSpinner = false
                                    ;
                                  });
                                  toastMethod(error.toString());
                                });

                              } catch (e) {
                                toastMethod(e.toString());
                                setState(() {
                                  showSpinner = false;
                                });
                              }
                            }
                          }),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void toastMethod(String message) {
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
