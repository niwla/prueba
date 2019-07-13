import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/model/table_class.dart';
import 'package:toast/toast.dart';
import 'package:eat_app/pages/home/table_description.dart';

class CustomCard extends StatelessWidget {
  final TableClass table;
  const CustomCard({Key key, this.table}) : super(key: key);

  Widget dot(Color color){
    return new Container(
      height: 20.0,
      width: 20.0,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(table.name),
        subtitle: table.available ? Text("Disponible") : Text("Ocupada"),
        trailing: dot(table.available ? Colors.green : Colors.red),
        onTap: (){
          if (table.available) {
            Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) => DescriptionTable(table: table,)));
          }else{
            Toast.show("Esta mesa no esta disponible",context, gravity: Toast.CENTER,duration: Toast.LENGTH_LONG);
          }
        },
      ),
    );
  }
}