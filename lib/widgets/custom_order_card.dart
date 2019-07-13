import 'package:eat_app/pages/home/order.dart';
import 'package:eat_app/pages/home/order_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/model/order_class.dart';
import 'package:eat_app/model/table_class.dart';
import 'package:eat_app/pages/home/table_description.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';

class CustomCard extends StatelessWidget {
  final OrderClass order;
  const CustomCard({Key key, this.order}) : super(key: key);

  Widget dot(BuildContext context){
    return Column(
      children: <Widget>[
        InkWell(
          splashColor: Colors.red,
          child: Padding(
            padding: EdgeInsets.only(top: 2,bottom: 10),
            child: Text("AGREGAR PRODUCTOS",style: TextStyle(color: Colors.red)),
          ),
          onTap: (){
            Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) => DescriptionTable(orderID: order.id,  table: new TableClass(order.table.id, order.table.name, true))));
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(order.table.name),
        subtitle: order.status ? Text("Finalizado") : Text(order.date),
        trailing: dot(context),
        onTap: (){
          Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) => DescriptionOrder(order: order,)));
        },
      ),
    );
  }
}