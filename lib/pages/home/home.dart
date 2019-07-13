import 'package:eat_app/pages/home/table.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_app/utils/shared_helper.dart';
import 'package:flutter/services.dart';
import 'table.dart';
import 'order.dart';
import 'package:eat_app/pages/login/login.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser _user;
  SharedHelper helper;
  
  void getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print(user.toString());
    setState(() {
      _user = user;
    });
  }
  int currentIndex = 0;

  @override
  initState() {
    getCurrentUser();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.red
    ));
    helper = new SharedHelper();
    super.initState();
  }

  getTitle(index){
    if (index==0) {
      return "Mesas";
    }else if(index==1){
      return "Pedidos";
    }
  }
  getBody(index){
    if (index==0) {
      return new Tables();
    }else if(index==1){
      return Order();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text(getTitle(currentIndex),style: TextStyle(color: Colors.white,fontSize: 27.0)),
      ),
      body: getBody(currentIndex),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(_user.displayName),
              accountEmail: Text(_user.email),
            ),            
            ListTile(
              title: Text('Mesas'),
              leading: Icon(Icons.dashboard),
              onTap: () {
                setState(() {
                  currentIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Pedidos'),
              leading: Icon(Icons.receipt),
              onTap: () {
                setState(() {
                  currentIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            Spacer(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Cerrar sesión'),
              onTap: () {
                _firebaseAuth.signOut();
                helper.setID('');
                helper.setIsLogin(false);
                Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => Login()));
              },
            )
          ],
        ),
      ),
    );
  }
} 