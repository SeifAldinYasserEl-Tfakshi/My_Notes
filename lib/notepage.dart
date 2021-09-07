import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:mynote/notetools/editnotes.dart';
import 'package:mynote/notetools/viewnotes.dart';

void main() => runApp(Notepage());


class Notepage extends StatefulWidget {
  final docid;
Notepage ({Key key,this.docid}):super(key: key);

@override
_NotepageState createState()=>_NotepageState();
}
class _NotepageState extends State<Notepage>{
  CollectionReference notesref= FirebaseFirestore.instance.collection("notes");
  getUser(){
    var user = FirebaseAuth.instance.currentUser;
    print(user.email);
  }
  @override
void initState(){

    getUser();
    super.initState();
}

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
  return Scaffold(
    appBar:AppBar(centerTitle: true,backgroundColor: Colors.black,actions: [
      IconButton(onPressed: ()async{
        await FirebaseAuth.instance.signOut();
        Navigator.of(context).pushNamed("Signin");
      }, icon: Icon(Icons.exit_to_app))
    ],

        title:Text("My Note",style: TextStyle(fontStyle: FontStyle.italic),)) ,
    floatingActionButton: FloatingActionButton(backgroundColor:Colors.black,child: Icon(Icons.add),
      onPressed: (){Navigator.of(context).pushNamed("Addnotes");},),
    body: Container(
      child: FutureBuilder(future: notesref.where("userid",isEqualTo: FirebaseAuth.instance.currentUser.uid).get(),
        builder: (context,snapshot){
      if (snapshot.hasData){
        return ListView.builder(
        itemCount: snapshot.data.docs.length
        ,itemBuilder: (context,i){
           return Dismissible(onDismissed:(direction) async{
       await notesref.doc(snapshot.data.docs[i].id).delete();
       await FirebaseStorage.instance.refFromURL(snapshot.data.docs[i]['imageurl']).delete().then((value) {
         print("delete");
       });
           } ,
               key: UniqueKey(), child: ListNotes(notes: snapshot.data.docs[i],
             docid:snapshot.data.docs[i].id ,));
        });
      }
return Center(child: CircularProgressIndicator());
        })
    ),
  );
  }

}class ListNotes extends StatelessWidget{
  final notes;
  final docid;
  final list;
  ListNotes({this.notes,this.docid,this.list});
  @override

  Widget build(BuildContext context) {
    // TODO: implement build

return InkWell(
onTap: (){
  Navigator.of(context).push(MaterialPageRoute(builder: (context){
    return ViewNote(notes: notes,);
  }));
},
  child:Card(

      child:Row(
            children: [
           Expanded(flex: 1,
               child: Image.network ("${notes['imageurl']}",fit: BoxFit.fill,height: 80,
                  ),),
      Expanded(flex: 3,
        child: ListTile (title: Text("${notes['title']}"),
          subtitle: Text("${notes['note']}",style: TextStyle(fontSize: 14),),
          trailing: IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context){
              return Editnotes(docid: docid,list: notes,);
            }));
          },icon: Icon(Icons.edit),
          ),
        ),)

    ],
  )));

  }
  
}