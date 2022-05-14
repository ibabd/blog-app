// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:blog_app_last/screen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blog_app_last/componant/round_buttom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_database/firebase_database.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';



class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //used image picker
  File ?_image;
  final picker=ImagePicker();
  TextEditingController titleController=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  //final _formKey=GlobalKey<FormState>();

  // ignore: deprecated_member_use
  final postRef=FirebaseDatabase.instance.reference().child('Posts');
  firebase_storage.FirebaseStorage storage=firebase_storage.FirebaseStorage.instance;
  bool showSpinner=false;
  final FirebaseAuth _auth=FirebaseAuth.instance;

  Future getImageGallery()async{
    final pickedFile=await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedFile !=null){
        _image=File(pickedFile.path);
      }else{
        toastMethod('No Image Selected');
      }
    });
  }
  Future getImageCamera()async{
    final pickedFile=await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if(pickedFile !=null){
        _image=File(pickedFile.path);
      }else{
        toastMethod('No Image Selected');
      }
    });
  }

  void dialog(context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Container(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      getImageCamera();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('camera'),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    ),
                  ),

                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(

          title: Text('Upload Blog'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            child: Column(
              children: [
                InkWell(
                  onTap: (){
                    dialog(context);
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height*.2,
                      width: MediaQuery.of(context).size.width*1,
                      child: _image !=null ?
                      ClipRRect(
                        child: Image.file(
                          _image!.absolute,
                          height: 100,
                          width: 100,
                          fit: BoxFit.fill,
                        ),
                      )
                      :Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: 100,
                        height: 100,
                        child: Icon(Icons.camera_alt,color: Colors.blue,),
                      )
                      ,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Form(
                 // key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Title*',
                          hintText: 'Enter post Title',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                          labelStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        minLines: 1,
                        decoration: InputDecoration(
                          labelText: 'Description*',
                          hintText: 'Enter post Description',
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                          labelStyle: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30,),
                RoundButtton(
                  onPress: ()async{
                    setState(() {
                      showSpinner=true;
                    });
                    try{
                      int date=DateTime.now().microsecondsSinceEpoch;
                      firebase_storage.Reference ref=firebase_storage.FirebaseStorage.instance.ref('blogApp$date');
                      var uploadTask=ref.putFile(_image!.absolute);
                      await Future.value(uploadTask);
                      var newUrl=await ref.getDownloadURL();
                      final User?user=_auth.currentUser;
                      postRef.child('Post List').child(date.toString()).set({
                        'pId':date.toString(),
                        'pImage':newUrl.toString(),
                        'pTime':date.toString(),
                        'pTitle':titleController.text.toString(),
                        'pDescription':descriptionController.text.toString(),
                        'uEmail':user!.email.toString(),
                        'uId':user.uid.toString(),

                      }).then((value) {
                        toastMethod('post published');
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen()));
                        setState(() {
                          showSpinner=false;
                        });

                      }).onError((error, stackTrace) {
                        toastMethod(error.toString());
                        setState(() {
                          showSpinner=false;
                        });
                      });

                    }catch(e){
                      setState(() {
                        showSpinner=false;
                      });
                      toastMethod(e.toString());
                    }
                  },
                  title: 'Upload',
                ),
              ],
            ),
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
        backgroundColor: Colors.white,
        textColor: Colors.black45,
        fontSize: 16.0
    );
  }
}
