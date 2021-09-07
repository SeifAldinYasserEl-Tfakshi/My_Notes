import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
final notes;
  ViewNote({Key key,this.notes }) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}
class _ViewNoteState extends State<ViewNote> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text("My Note",style: TextStyle(fontStyle: FontStyle.italic),),
          centerTitle: true,backgroundColor: Colors.black,
    ),
      body: Container(child: Column(
        children: [
Container(margin: EdgeInsets.symmetric(vertical: 15),
  child: Image.network("${widget.notes['imageurl']}",width: double.infinity,height: 280,fit: BoxFit.fill,),
),Container(child: Text("${widget.notes['title']}",style: TextStyle(fontSize: 30,
              fontStyle: FontStyle.italic)),),
          Container(child: Text("${widget.notes['note']}",style: TextStyle(fontSize: 20,
              fontStyle: FontStyle.italic)),)
        ],
      ),),
    );
  }
}
