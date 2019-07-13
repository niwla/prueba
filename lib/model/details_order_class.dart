class DetailsOrder {
  
  String _name;
  int _cant;
  int _price;
  int _subtotal;
  
  DetailsOrder(this._name, this._cant, this._price,this._subtotal);

  String get name => _name;
  int get cant => _cant;
  int get price => _price;
  int get subtotal => _subtotal;

 
  DetailsOrder.fromDocument(Map<String, dynamic> document) {
    this._name = document['name'];
    this._cant = int.parse(document['cant']);
    this._price = int.parse(document['price']);
    this._subtotal = int.parse(document['subtotal']);
  }

  DetailsOrder.fromJson(Map<dynamic, dynamic> parsedJson){
    this._name = parsedJson['name'];
    this._cant = int.parse(parsedJson['cant']);
    this._price = int.parse(parsedJson['price']);
    this._subtotal = int.parse(parsedJson['subtotal']);
  }
}