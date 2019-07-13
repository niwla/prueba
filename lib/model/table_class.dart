class TableClass {
  
  String _id;
  String _name;
  bool _available;
  
  TableClass(this._id, this._name, this._available);
 
  String get id => _id;
  String get name => _name;
  bool get available => _available;

 
  TableClass.fromDocument(Map<String, dynamic> document,String id) {
    this._id = id;
    this._name = document['name'];
    this._available = document['available'];
  }
  
  TableClass.fromJson(Map<dynamic, dynamic> parsedJson){
    this._id = parsedJson["id"];
    this._name = parsedJson['name'];
    this._available = false;
  }

}