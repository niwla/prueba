import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/widgets/custom_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_app/model/table_class.dart';

class Tables extends StatefulWidget {
  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('tables').orderBy('name',descending: false).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                return ListView(
                  children: snapshot.data.documents.map((DocumentSnapshot document) {
                    return CustomCard(table: TableClass.fromDocument(document.data, document.documentID));
                  }).toList(),
              );
            }
          },
        )
      ),
    );
  }
}