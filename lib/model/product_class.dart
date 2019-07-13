class ProductClass {
  
  String _id;
  String _name;
  String _category;
  int _price;
  List<dynamic> _ingredients;
  
  ProductClass(this._id, this._name, this._ingredients, this._category, this._price);
 
  String get id => _id;
  String get category => _category;
  String get name => _name;
  int get price => _price;
  List<dynamic> get ingredients => _ingredients;

 
  ProductClass.fromDocument(Map<String, dynamic> document,String id) {
    this._id = id;
    this._ingredients = document['ingredients'];
    this._name = document['name'];
    this._category = document['category'];
    this._price = document['price'];
  }

  ProductClass.fromJson(Map<dynamic, dynamic> parsedJson){
    this._id = parsedJson['id'];
    this._name = parsedJson['name'];
    this._ingredients = parsedJson['ingredients'];
    this._category = parsedJson['category'];
    this._price = parsedJson['price'];
  }
}