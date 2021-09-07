import 'package:flutter/material.dart';

showLoading(context){
  return showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Text("Please Wait"),
      content: Container(child:Center(child: CircularProgressIndicator(),),height: 50,)
    );
  });
}