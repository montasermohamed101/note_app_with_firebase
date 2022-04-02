
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:note_app/auth/log_in.dart';
import 'package:note_app/crud/addnotes.dart';
import 'package:note_app/crud/editnotes.dart';
import 'package:note_app/home_page.dart';
import 'package:note_app/test.dart';
import 'auth/sign_up.dart';
bool? isLogin;
//  Future backgroundMessage(RemoteMessage message)async{
//     print('=============Back Ground Message==========');
//     print('${message.notification!.body}');
// }
void main() async{
  WidgetsFlutterBinding.ensureInitialized();// if i have async and await in main to check the initialized before build widget
  await Firebase.initializeApp();

 // FirebaseMessaging.onBackgroundMessage((message) => backgroundMessage(message));


  var user = FirebaseAuth.instance.currentUser;
  if(user == null){
    isLogin = false;
  }else{
    isLogin = true;
  }
  runApp( MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        buttonColor: Colors.indigo,
        textTheme: TextTheme(
          headline6: TextStyle(fontSize: 20,color: Colors.black),
          headline5: TextStyle(fontSize: 30,color: Colors.blue,fontWeight: FontWeight.w900),
          bodyText1: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold),
        )
      ),
      home: isLogin == false ? Login() : HomePage() ,
      routes: {
        'login':(context) => Login(),
        'signup':(context) => SignUp(),
        'homepage':(context) => HomePage(),
        'addnotes':(context) => AddNotes(),
      },
    );
  }
}
//isLogin  == false ? Login() : HomePage()