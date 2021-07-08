import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('firebase')
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError){
            return new Text('Error: ${snapshot.error}');
          }
          else{
            switch(snapshot.connectionState){
              case ConnectionState.waiting: return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document){
                    return new ListTile(
                      title: new Text(document['title']),
                      subtitle: new Text(document['author']),
                    );
                  }).toList()
                );
            }
          }
        }
      ),
    );
  }
}