import 'package:flutter/material.dart';

class Counter extends StatelessWidget {
  final Function sum;
  final Function rest;
  final String cant;

  const Counter({Key key, this.sum, this.rest, this.cant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return 
        Container(
          width: 100,
          height: 30,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: rest,
                  child: Container(
                    color: Colors.red,
                    height: 25.0,
                    child: Center(child: Text("-",style: TextStyle(fontSize: 20,color: Colors.white))),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: double.infinity,
                    child: Center(
                      child: Text(cant,style: TextStyle(fontSize: 20,color: Colors.blueGrey.shade900)),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 3,
                child: GestureDetector(
                  onTap: sum,
                  child: Container(
                    color: Colors.red,
                    height: 25.0,
                    child: Center(child: Text("+",style: TextStyle(fontSize: 20,color: Colors.white))),
                  ),
                ),
              )
            ],
          ),
        );
  }
}