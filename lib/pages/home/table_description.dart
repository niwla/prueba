import 'package:eat_app/model/product_class.dart';
import 'package:eat_app/model/table_class.dart';
import 'package:eat_app/model/details_order_class.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:eat_app/widgets/counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class DescriptionTable extends StatefulWidget {
  final TableClass table;
  final String orderID;
  const DescriptionTable({Key key, this.table, this.orderID = ''}) : super(key: key);
  @override
  _DescriptionTableState createState() => _DescriptionTableState();
}

class _DescriptionTableState extends State<DescriptionTable> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  int _cant = 1;
  DocumentReference docRef;
  int total = 0;
  FirebaseUser user;
  static final List<ProductClass> product = new List<ProductClass>();
  static final List<int> cantidad = new List<int>();
  List<String> category = new List<String>();
  List<DetailsOrder> order = new List<DetailsOrder>();
  List<Map<String, dynamic>> listOMaps;
  
  @override
  void initState() {
  
    product.clear();
    cantidad.clear();
    order.clear();
    total = 0;
    Firestore.instance.collection('category').orderBy('name',descending: false).snapshots().listen((data)=>data.documents.forEach((doc)=>{
      category.add(doc.data["name"])
    }));
    Firestore.instance.collection('products').orderBy('name',descending: false).snapshots().listen((data)=>data.documents.forEach((doc)=>{
      setState(() {
        product.add(ProductClass.fromDocument(doc.data, doc.documentID));
        cantidad.add(0);
      })
    }));
    
    getCurrentUser();
    super.initState();
  }

  void getCurrentUser() async {
    user = await _firebaseAuth.currentUser();
  }
  
  List<Widget> buildExpandableContent(String category) {
    List<Widget> columnContent = [];
    for (var i = 0; i<product.length; i++ ){
      if (product[i].category==category) {
        columnContent.add(
          new ListTile(
            onTap: () {
              //Navigator.of(context).push(new CupertinoPageRoute(builder: (BuildContext context) => ProductDescription(product: product[i])));
            },
            title: new Text(product[i].name, style: new TextStyle(fontSize: 18.0),),
            contentPadding: EdgeInsets.all(2),
            subtitle: Text("Precio: \$" + product[i].price.toStringAsFixed(0)),
            trailing: Counter(
              cant: cantidad[i].toString(),
              sum: (){
                setState(() { 
                  cantidad[i]++; 
                  total+= product[i].price;
                });
              },
              rest: (){
                setState(() {
                  // ignore: unnecessary_statements
                  if (cantidad[i]== 0) {
                    cantidad[i] = 0;
                    total-= 0;
                  }else{
                    cantidad[i]--;
                    total-=product[i].price;
                  }
                });
              },
            )
          )
        ); 
      }
    }
    return columnContent;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.table.name,style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 27.0)),
        iconTheme: IconThemeData(color: Colors.blueGrey.shade900),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Numero de clientes :',style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 17.0)),
                Counter(
                  cant: _cant.toString(),
                  sum: (){
                    setState(() { 
                      _cant++;
                    });
                  },
                  rest: (){
                    setState(() {
                      // ignore: unnecessary_statements
                      _cant==1 ? 1 : _cant--;
                    });
                  },
                ),
              ]
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text("Elija el producto"),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: category.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return new ExpansionTile(
                    title: Text(category[index]),
                    children: buildExpandableContent(category[index]),
                  );
                }
              ),
            ),
            Center(child: Text("Total: \$" + total.toStringAsFixed(0),style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 25))),
            SizedBox(height: 20),
            FlatButton(
              color: Colors.red,
              onPressed: () => {
                for (var i=0; i< product.length; i++) {
                  if (cantidad[i]!=0) {
                    order.add(new DetailsOrder(
                      product[i].name,
                      cantidad[i],
                      product[i].price,
                      (product[i].price * cantidad[i])
                    )),
                  },
                },
                listOMaps = order.map((something) => {
                  "name": something.name,
                  "price": something.price,
                  "cant": something.cant,
                  "sub_total": something.subtotal,
                }).toList(),
                if (total!=0) {
                  if (widget.orderID!='') {
                    Firestore.instance.collection("details").add({
                      "ref" : widget.orderID,
                      "details" : listOMaps,
                      "total" : total
                    }),
                    Toast.show("Pedido agregado", context,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG),
                    Navigator.pop(context),
                  }else{
                    Firestore.instance.collection('order').add({
                      "date": DateTime.now().toString().substring(0, 10),
                      "clients" : _cant,
                      "table": Map.castFrom({"name": widget.table.name,"id" : widget.table.id}),
                      "status": false,
                      "user_id": user.uid,
                      "user_email": user.displayName,
                    }).then((result) => {                  
                      Firestore.instance.collection("details").add({
                        "ref" : result.documentID,
                        "details" : listOMaps,
                        "total" : total
                      }),
                      Firestore.instance.collection('tables').document(widget.table.id).updateData({"available" : false}),
                      Toast.show("Pedido agregado", context,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG),
                      Navigator.pop(context)
                    }).catchError((err) => print(err)) as DocumentReference,
                    Firestore.instance.collection('tables').document(widget.table.id).updateData({"available" : false})
                    .catchError((e) {
                      print(e);
                    }),
                  },
                }else{
                  Toast.show("Seleccione por lo menos un producto", context,gravity: Toast.CENTER,duration: Toast.LENGTH_LONG),
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
                      child: Text("GUARDAR PEDIDO", textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        )
      )     
    );
  }
}