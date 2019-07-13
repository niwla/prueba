import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/login/login.dart';
import 'pages/home/home.dart';

Future<void> main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var login = prefs.getBool('is_login') == null ?  false : true;
  
  runApp(MaterialApp(
      title: 'Eat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red,
      ),
      home: login ? MainHome() : Login()
    )
  );
}