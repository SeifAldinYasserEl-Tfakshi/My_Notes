import 'dart:io';
import 'dart:math';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote/alert.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Addnotes extends StatefulWidget {
  Addnotes({Key key}) : super(key: key);

  @override
  _AddnotesState createState() => _AddnotesState();
}
  class _AddnotesState extends State<Addnotes> {
  CollectionReference notesref= FirebaseFirestore.instance.collection("notes");
  var note, title,imageurl;
  Reference ref;
  File file;
  GlobalKey <FormState> formstate = new GlobalKey<FormState>();
  addNotes(context)async{

    if(file==null)
      return AwesomeDialog(context: context,
     title: "Important note" ,
      body: Text("Please Choose Image"),
      dialogType: DialogType.ERROR)..show();

    var formdata= formstate.currentState;
 if (formdata.validate()){
   showLoading(context);
  formdata.save();
  await ref .putFile(file);
  imageurl = await ref.getDownloadURL();

  await notesref.add({
    "title" : title ,
    "note" : note,
    "imageurl" : imageurl
    ,
    "userid": FirebaseAuth.instance.currentUser.uid
  }).then((value) {
    Navigator.of(context).pushNamed("Notepage");
  }).catchError((e){
    print("$e");
  });
 }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
     appBar: AppBar(title: Text("My Note",style: TextStyle(fontStyle: FontStyle.italic),),centerTitle: true,backgroundColor: Colors.black,
     ),
     body: Container(child: Column(
       children: [
         Form(
           key: formstate,
             child: Column(children: [
           TextFormField(
             validator: (val){
               if ((val.length > 30)) {
                 return "Title cannot be larger than 30 letter";
               }   if ((val.length < 1)) {
                 return "Title cannot be smaller than 1 letter";
               }
               return null;
             },

             onSaved: (val){
             title = val;
             },
             maxLength:30,
             decoration: InputDecoration(
               filled: true,
               fillColor: Colors.white,
               labelText: "Title",
               prefixIcon: Icon(Icons.note)
             ),
           ), TextFormField(
                 validator: (val){
                   if ((val.length > 1000)) {
                     return "Note cannot be larger than 1000 letter";
                   }   if ((val.length < 1)) {
                     return "Note cannot be smaller than 1 letter";
                   }
                   return null;
                 },

                 onSaved: (val){
                   note = val;
                 },
             minLines: 1,
             maxLines: 3,
             maxLength:1000,
             decoration: InputDecoration(
                 filled: true,
                 fillColor: Colors.white,
                 labelText: "Note",
                 prefixIcon: Icon(Icons.note)
             ),
           ),RaisedButton(onPressed: (){showBottomSheet(context);},
             padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 38),
             color: Colors.black,
             splashColor: Colors.grey,
             textColor: Colors.black,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(18.0),
               side: BorderSide(color: Colors.grey),
             ),
             child: Text("Add Image",style: TextStyle(
                 fontFamily: "Times New Roman",
                 fontStyle: FontStyle.italic,
                 color: Colors.white,fontSize: 25)),
            ),SizedBox(height: 18,),
           RaisedButton(onPressed: () async {
             await addNotes(context);
             },
             padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 38),
             color: Colors.black,
             splashColor: Colors.grey,
             textColor: Colors.black,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(18.0),
               side: BorderSide(color: Colors.grey),
             ),
             child: Text("Add Note",style: TextStyle(
                 fontFamily: "Times New Roman",
                 fontStyle: FontStyle.italic,
                 color: Colors.white,fontSize: 25)),
            )
         ],))
       ],
     ),

     ),
   );

  }

 showBottomSheet(context){
    return showModalBottomSheet(context: context, builder: (context){
      return Container(height: 180,
        padding: EdgeInsets.all(20),

        child: Column(
          children: [
          Text("Choose Image",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

            InkWell(onTap: ()async{
              var picked = await ImagePicker().getImage(source: ImageSource.gallery);
              if (picked != null){
                file= File(picked.path);
                var rand = Random().nextInt(100000);
                var imagename= "$rand"+basename(picked.path);
                ref = FirebaseStorage.instance.ref("images").child("$imagename");
Navigator.of(context).pop();
              }
            },
              child: Container(width: double.infinity,

                  padding: EdgeInsets.all(10),child:Row(children: [Icon(Icons.photo_album_outlined,size: 30,),
                SizedBox(width: 20,),
                    Text("From Gallery",style: TextStyle(fontSize: 20),)
                  ],)

              ),
            ),
            InkWell(onTap: ()async{
              var picked = await ImagePicker().getImage(source: ImageSource.camera);
              if (picked != null){
                file= File(picked.path);
                var rand = Random().nextInt(100000);
                var imagename= "$rand"+basename(picked.path);
             ref = FirebaseStorage.instance.ref("images").child("$imagename");
                Navigator.of(context).pop();
              }
            },
              child: Container(width: double.infinity,
                
                padding: EdgeInsets.all(10),child:Row(children: [Icon(Icons.camera,size: 30,),
                SizedBox(width: 20,),
                    Text("From Camera",style: TextStyle(fontSize: 20),)
                ],)
              
              ),
            )
        ],),

      );
    });
 }

  }


