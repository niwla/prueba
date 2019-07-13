import 'package:cloud_firestore/cloud_firestore.dart' as prefix0;
import 'package:eat_app/model/order_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DescriptionOrder extends StatefulWidget {
  final OrderClass order;
  
  const DescriptionOrder({Key key, this.order}) : super(key: key);
  
  @override
  _DescriptionOrderState createState() => _DescriptionOrderState();
}

class _DescriptionOrderState extends State<DescriptionOrder> {
  double total = 0;
  List<Map<dynamic,dynamic>> detalles = new List<Map<dynamic,dynamic>>();

  @override
  void initState() {
    total = 0;
    detalles.clear();


    Firestore.instance.collection('details').where("ref",isEqualTo: widget.order.id).snapshots().listen((data)=>data.documents.forEach((doc)=>{
      setState(() {      
        for (var item in doc["details"]) {
          total += item["sub_total"];
          detalles.add({
          "name" : item["name"],
          "cant" : item["cant"],
          "sub_total" : item["sub_total"],
        }); 
        }
      }),
    }));
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Orden de " + widget.order.table.name,style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 27.0)),
        iconTheme: IconThemeData(color: Colors.blueGrey.shade900),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              Text("Producto",style: TextStyle(color: Colors.red,fontSize: 17.0)),
              Text("Cantidad",style: TextStyle(color: Colors.red,fontSize: 17.0)),
            //  Text("Nota",style: TextStyle(color: Colors.red,fontSize: 17.0))
              ]
            ),
            Expanded(
              child: ListView.builder(
                itemCount: detalles.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    title: Text(detalles[index]["name"]),
                    subtitle: Text("SubTotal \$: " + detalles[index]["sub_total"].toString()),
                    trailing: Text(detalles[index]["cant"].toString()),
                  );
                }
              ),
            ),
            /*!widget.order.status ? 
            FlatButton(
              child: Text("AGREGAR MAS PRODUCTO",style: TextStyle(color: Colors.red)),
              onPressed: (){
                Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) => DescriptionTable(orderID: widget.order.id,  table: new TableClass(widget.order.table.id, widget.order.table.name, true))));
              },
            ) : Text(""),*/
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Total: \$" + total.toStringAsFixed(0),style: TextStyle(fontSize: 22.0,color: Colors.blueGrey.shade900)),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () => {
                if(widget.order.status){
                  Navigator.pop(context)
                }else{
                  Firestore.instance.
                  collection('order').
                  document(widget.order.id).
                  updateData({"status" : true}),
                  Firestore.instance
                  .collection('tables')
                  .document(widget.order.table.id)
                  .updateData({"available" : true})
                  .catchError((e) {
                    print(e);
                  }),
                  Toast.show("Pedido terminado", context,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG),
                  Navigator.pop(context)
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 20.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child:Text(widget.order.status ? "ACEPTAR":  "FINALIZAR PEDIDO", textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),

      )
    );
  }
}