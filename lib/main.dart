import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote/Registrationservices/SignIn.dart';
import 'package:mynote/Registrationservices/register.dart';
import 'package:mynote/notepage.dart';
import 'package:mynote/notetools/addnotes.dart';
import 'package:page_transition/page_transition.dart';

bool isLogin;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var user = FirebaseAuth.instance.currentUser;
 if(user==null){
   isLogin = false;
 }else{
   isLogin = true;
 }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
      title: 'mynote',
        home:   isLogin==false? SignIn() :Notepage(),
      routes: {
      "Addnotes": (context)=> Addnotes(),
      "Notepage": (context)=> Notepage(),
      "Signin": (context) => SignIn(),
      "register": (context) => register(),
      },
    );

  }
}
