import 'package:flutter/material.dart';
import 'package:eat_app/model/product_class.dart';
import 'package:eat_app/widgets/counter.dart';

class ProductDescription extends StatefulWidget {
  final ProductClass product;
  
  const ProductDescription({Key key, this.product}) : super(key: key);

  @override
  _ProductDescriptionState createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  int _cant = 0;
  double total = 0;
  bool simon = true;
  List<String> ingredients = new List<String>();
  List<bool> added = new List<bool>();

  @override
  void initState() {
    for( var value in  widget.product.ingredients){
      setState(() {
        added.add(true);
        ingredients.add(value.toString());
      });
    }
    super.initState();
  }
          
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.product.name,style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 27.0)),
        iconTheme: IconThemeData(color: Colors.blueGrey.shade900),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[

          /*new TextField(
            keyboardType: TextInputType.text,
            decoration: new InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'nota',
            ),
            ),
            */
            ListTile(
              title: Text('Cantidad del producto :',style: TextStyle(color: Colors.blueGrey.shade900,fontSize: 17.0)),
              subtitle: Text("Precio: \$" + widget.product.price.toStringAsFixed(0)),
              
              trailing: Counter(
                cant: _cant.toString(),
                sum: (){
                  setState(() { 
                    _cant++; 
                    total+= widget.product.price;
                  });
                },
                rest: (){
                  setState(() { 
                    if (_cant== 0) {
                      _cant = 0;
                      total-= 0;
                    }else{
                      _cant--;
                      total-=widget.product.price;
                    }
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: ingredients.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    title: Text(ingredients[index]),
                    trailing: Checkbox(
                      value: added[index],
                      activeColor: Colors.red,
                      onChanged: (bool value) {
                        setState(() {
                          added[index] = value;
                        });
                      },
                    ),
                  );
                }
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text("Total: \$" + total.toStringAsFixed(0),style: TextStyle(fontSize: 22.0,color: Colors.blueGrey.shade900)),
            ),
            FlatButton(
              color: Colors.red,
              onPressed: () => {              
                
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
                      child: Text("GUARDAR CAMBIOS", textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]
        )
      )
    );
  }
}