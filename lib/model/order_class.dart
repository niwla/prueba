import 'table_class.dart';

class OrderClass {
  String _id;
  String _date;
  int _client;
  //dynamic _details;
  bool _status;
  TableClass _tableClass;
  String _userEmail;
  String _userId;
  double _total;
  
  OrderClass(this._id,this._client,this._date,this._status,this._tableClass,this._userEmail,this._userId,this._total);
 
  String get id => _id;
  String get date => _date;
  int get client => _client;
  //dynamic get details => _details;
  bool get status => _status;
  TableClass get table => _tableClass;
  String get useremail => _userEmail;
  String get userid => _userId;
  double get total => _total;
  
  OrderClass.fromDocument(Map<String, dynamic> document, String id) {
    this._id = id;
    this._tableClass = TableClass.fromJson(document['table']);
    this._client = document['clients'];
    this._userEmail = document['user_email'];
    this._userId = document['user_id'];
    this._date = document['date'];
    this._status = document['status'];
    this._total = document['total'];
    //this._details = document['details'];
  }
  
}