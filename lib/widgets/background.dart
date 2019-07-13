import 'package:flutter/material.dart';
class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Container(
          height: size.height * 0.4,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: <Color> [
                Color.fromRGBO(255, 133, 82, 1.0),
                Color.fromRGBO(255, 45, 0, 1.0)
              ]
            )
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 80.0),
          child: Column(
            children: <Widget>[
              Icon( Icons.assignment, color: Colors.white, size: 100.0 ),
              SizedBox( height: 10.0, width: double.infinity ),
              Text('Eat App', style: TextStyle( color: Colors.white, fontSize: 25.0 ))
            ],
          ),
        )
      ],
    );
  }
}