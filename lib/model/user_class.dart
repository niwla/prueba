class UserClass {
  
  String _id;
  String _photoPath;
  String _name;
  String _lastname;
  String _email;
  String _password;
  
  UserClass(this._id,this._photoPath, this._name, this._lastname, this._email, this._password);
 
  String get id => _id;
  String get name => _name;
  String get photo => _photoPath;
  String get lastname => _lastname;
  String get email => _email;
  String get password => _password;


 
  UserClass.fromDocument(Map<String, dynamic> document,String id) {
    this._id = id;
    this._photoPath = document['photo'];
    this._name = document['name'];
    this._lastname = document['lastname'];
    this._email = document['email'];
    this._password = document['password'];
  }

  UserClass.fromJson(Map<dynamic, dynamic> parsedJson){
    this._id = parsedJson['id'];
    this._photoPath = parsedJson['photo'];
    this._name = parsedJson['name'];
    this._lastname = parsedJson['lastname'];
    this._email = parsedJson['email'];
    this._password = parsedJson['password'];
  }
}