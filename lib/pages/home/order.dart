import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/model/order_class.dart';
import 'package:eat_app/widgets/custom_order_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Order extends StatefulWidget {
  @override
  _OrderState createState() => _OrderState();

  static restartApp(BuildContext context) {
    final _OrderState state =
        context.ancestorStateOfType(const TypeMatcher<_OrderState>());
    state.restartApp();
  }
}

class _OrderState extends State<Order> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  Key key = new UniqueKey();

  void restartApp() {
    this.setState(() {
      key = new UniqueKey();
    });
  }

  void getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print(user.toString());
    setState(() {
      _user = user;
    });
  }

  @override
  initState() {
   getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      backgroundColor: Colors.white,
      body:Container(
        padding: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('order').where("status",isEqualTo: false).orderBy('date',descending: true).
          where("user_id", isEqualTo: _user.uid).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError)
              return Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: snapshot.data == null || snapshot == null  ? Text("Sin datos por ahora") : CircularProgressIndicator());
              default:
                  return ListView(
                    children: snapshot.data.documents.map((DocumentSnapshot document) {
                      return CustomCard(order: OrderClass.fromDocument(document.data, document.documentID));
                    }).toList(),    
                  );
                }
          },
        )
      ),
    );
  }
}