import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SignIn extends StatefulWidget {
  SignIn ({Key key}) : super (key: key);
  @override
  _SignIn createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  var  myemail, mypassword ;
  bool _isObscure = true;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  SignIn() async{
    var formdata = formstate.currentState ;
    formdata.save();
    if(formdata.validate()){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: myemail,
            password: mypassword
        );return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {AwesomeDialog(
            context: context,
            title: "error",
            body: Text("No user found for that email."))..show();

        } else if (e.code == 'wrong-password') {AwesomeDialog(
            context: context,
            title: "error",
            body: Text("Wrong password provided for that user."))..show();

        }
      }
    }else{
      print("Not Vaild");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/loginpage.jpg"),fit: BoxFit.fill)),
        child: ListView(children: <Widget>[Container(
          child: Form(
            key: formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget> [

                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      SizedBox(height: 350),
                      TextFormField(    onSaved: (val){
                        myemail = val ;
                      },
                        validator: (val){
                          if ((val.length > 100)) {
                            return "Email cannot be larger than 1oo letter";
                          }   if ((val.length < 10)) {
                            return "Email cannot be smaller than 10 letter";
                          }
                          return null;
                        },

                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ), prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                            suffixStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            hintStyle: new TextStyle(fontStyle:FontStyle.italic,fontFamily:"Times New Roman",color: Colors.black),
                            hintText: "Enter Your Email",


                            fillColor: Colors.white70),

                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        obscureText: _isObscure,
                        onSaved: (val){
                          mypassword = val ;
                        },
                        validator: (val){
                          if ((val.length > 100)) {
                            return "Password cannot be larger than 1oo letter";
                          }   if ((val.length < 4)) {
                            return "Password cannot be smaller than 4 letter";
                          }
                          return null;
                        },


                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(30.0),
                              ),
                            ),    prefixIcon: IconButton(icon:Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off,color: Colors.black,
                        ),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },

                        ),
                            suffixStyle: const TextStyle(color: Colors.black),
                            filled: true,
                            hintStyle: new TextStyle(fontStyle:FontStyle.italic,fontFamily:"Times New Roman",color: Colors.black),
                            hintText: "Enter Your Password",
                            fillColor: Colors.white70),
                      ),
                      SizedBox(height: 5),
                      FlatButton(
                        child: Text('Not registerd? Sign up',style: TextStyle(fontSize: 18),),
                        onPressed: (){
                          Navigator.of(context).pushReplacementNamed("register");
                        },
                        textColor: Colors.white,
                      ),
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Container(child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 38),
                          color: Colors.black,
                          splashColor: Colors.grey,
                          textColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.grey),
                          ), child: Text("Sign In",style: TextStyle(
                            fontFamily: "Times New Roman",
                            fontStyle: FontStyle.italic,
                            color: Colors.white,fontSize: 25)), onPressed: () async{
                          var user = await SignIn();
                          if (user!=null){
                            AwesomeDialog(
                              context: context,
                              animType: AnimType.SCALE,
                              dialogType: DialogType.SUCCES,
                              title: "Success",
                              body: Center(child: Text(

                                'Successfully Signed In.',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),),
                              btnOkOnPress: () {   Navigator.of(context).pushReplacementNamed("Notepage");},
                            )..show();
                          }
                        },
                        ),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

        )],

        ),
      ),
    );
  }
}

// TODO Implement this library.