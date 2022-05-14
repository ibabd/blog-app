// ignore_for_file: deprecated_member_use, prefer_const_constructors

import 'package:blog_app_last/screen/add_post_screen.dart';
import 'package:blog_app_last/screen/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final  dbRef=FirebaseDatabase.instance.reference().child('Posts');
  FirebaseAuth auth=FirebaseAuth.instance;
  TextEditingController searchController=TextEditingController();
  String search='';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Blog'),
          centerTitle: true,
          actions:  [
            InkWell(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>const AddPostScreen()));
                },
                child: const Icon(Icons.add,)),
            const SizedBox(width: 20,),
            InkWell(
                onTap: (){
                  auth.signOut().then((value) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  });

                },
                child: const Icon(Icons.logout,)),
            const SizedBox(width: 20,),
          ],
        ),
        body:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Search with blog title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                controller: searchController,
                keyboardType: TextInputType.emailAddress,
                onChanged: (String value){
                  setState(() {
                    search=value;
                  });
                },
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: dbRef.child('Post List'),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    Map<dynamic, dynamic> values = snapshot.value! as Map<dynamic, dynamic>;
                    String tempTitle=values['pTitle']!;
                   if(searchController.text.isEmpty){
                     return Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.grey.shade100,
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: FadeInImage.assetNetwork(
                                 fit: BoxFit.fill,
                                 height: 300,
                                 width: double.infinity,
                                 placeholder: 'images/logo.jpg',
                                 image: values['pImage']!,
                               ),
                             ),
                             SizedBox(height: 10,),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0),
                               child: Text(values['pTitle']!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10),
                               child: Text(values['pDescription']!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
                             ),
                           ],
                         ),
                       ),
                     );
                   }
                   else if(tempTitle.toLowerCase().contains(searchController.text.toString())){
                     return Padding(
                       padding: const EdgeInsets.all(10.0),
                       child: Container(
                         decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(10),
                           color: Colors.grey.shade100,
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           mainAxisAlignment: MainAxisAlignment.start,
                           children: [
                             ClipRRect(
                               borderRadius: BorderRadius.circular(10),
                               child: FadeInImage.assetNetwork(
                                 fit: BoxFit.fill,
                                 height: MediaQuery.of(context).size.height*.2,
                                 width: MediaQuery.of(context).size.width*.25,
                                 placeholder: 'images/logo.jpg',
                                 image: values['pImage']!,
                               ),
                             ),
                             SizedBox(height: 10,),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10.0),
                               child: Text(values['pTitle']!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                             ),
                             Padding(
                               padding: const EdgeInsets.symmetric(horizontal: 10),
                               child: Text(values['pDescription']!,style: TextStyle(fontSize: 15,fontWeight: FontWeight.normal),),
                             ),
                           ],
                         ),
                       ),
                     );
                   }else{
                      return Container();
                   }
                  },


                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
