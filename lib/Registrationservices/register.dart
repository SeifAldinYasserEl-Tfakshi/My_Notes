import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';




class register extends StatefulWidget {
  register ({Key key}) : super (key: key);
  @override
  _register createState() => _register();
}

class _register extends State<register> {

  var myusername, myemail, mypassword ;
  bool _isObscure = true;

  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  register() async{
    var formdata = formstate.currentState ;
    if(formdata.validate()){
      formdata.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: myemail,
            password: mypassword);
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("Password is weak"))..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: "error",
              body: Text("The account already exists for that email."))..show();
        }
      } catch (e) {
        print(e);
      }
    }else{

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/loginpage.jpg"), fit: BoxFit.fill
            )
        ),
        child: ListView(children: <Widget>[
          Container(
            child: Form(
              key: formstate,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      children: [ SizedBox(height: 350),
                        TextFormField(
                          onSaved: (val){
                            myusername = val ;
                          },
                          validator: (val){
                            if ((val.length > 100)) {
                              return "Username cannot be larger than 1oo letter";
                            }   if ((val.length < 2)) {
                              return "Username cannot be smaller than 2 letter";
                            }
                            return null;
                          },
                          decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(30.0),
                                ),
                              ),
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                              suffixStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              hintStyle: new TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Times New Roman",
                                  color: Colors.black),
                              hintText: "Enter Your UserName",
                              fillColor: Colors.white70),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 30),
                        TextFormField(onSaved: (val){
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
                              ),
                              prefixIcon: const Icon(
                                Icons.alternate_email,
                                color: Colors.black,
                              ),
                              suffixStyle: const TextStyle(color: Colors.black),
                              filled: true,
                              hintStyle: new TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Times New Roman",
                                  color: Colors.black),
                              hintText: "Enter Your Email",
                              fillColor: Colors.white70),
                          style: TextStyle(color: Colors.black),
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
                              ),
                              prefixIcon: IconButton(icon:Icon(
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
                              hintStyle: new TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontFamily: "Times New Roman",
                                  color: Colors.black),
                              hintText: "Create Your Password",
                              fillColor: Colors.white70),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 30),
                        Column(

                          children: [Container(
                            child: RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 38),
                              color: Colors.black,
                              splashColor: Colors.grey,
                              textColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.grey),
                              ),
                              child: Text("Sign Up", style: TextStyle(
                                  fontFamily: "Times New Roman",
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white, fontSize: 25)),
                              onPressed: ()async {
                                UserCredential response = await register();
                                print(response.user.email);
                                if (response!= null){

                                  await FirebaseFirestore.instance.collection("users").add({
                                    "username" : myusername,
                                     "email" :   myemail
                                  });

                                  AwesomeDialog(
                                  context: context,
                                  animType: AnimType.SCALE,
                                  dialogType: DialogType.SUCCES,
                                  title: "Success",
                                  body: Center(child: Text(

                                    'Successfully Signed Up.',
                                    style: TextStyle(fontStyle: FontStyle.italic),
                                  ),),
                                  btnOkOnPress: () {   Navigator.of(context).pushReplacementNamed("Notepage");},
                                )..show();


                                }else{
                                  print("Sign Up Failed");
                                }
                              },),
                          ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),)
        ],

        ),
      ),
    );
  }

}
// TODO Implement this library.