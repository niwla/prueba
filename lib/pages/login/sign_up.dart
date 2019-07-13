import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eat_app/model/user_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/utils/util.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_app/widgets/background.dart';
import 'package:eat_app/pages/home/home.dart';
import 'package:eat_app/utils/shared_helper.dart';
import 'login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool passwordVisible = false;
  bool _autoValidate = false;
  String _name,_lastname,_email,_password;
  SharedHelper helper;
  static final List<UserClass> user = new List<UserClass>();



  Future<FirebaseUser> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    return user;
  }

  @override
  void initState() {
    passwordVisible = true;
    helper = new SharedHelper();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          _loginForm( context ),
        ],
      )
    );
  }

  Widget _loginForm(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              height: 120.0,
            ),
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric( vertical: 30.0 ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                Text('Crear cuenta', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.0,right: 30.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Nombre',
                          ),
                          onSaved: (String val) { _name = val; }
                        ),
                        Padding(padding:EdgeInsets.only(top: 24)),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Apellidos',
                          ),
                          onSaved: (String val) { _lastname = val; }
                        ),
                        Padding(padding:EdgeInsets.only(top: 24)),
                        TextFormField(
                          validator:Utils.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Correo electronico',
                            hintText: 'algo@gmail.cl',
                          ),
                          onSaved: (String val) { _email = val; }
                        ),
                        Padding(padding:EdgeInsets.only(top: 24)),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            suffixIcon: IconButton(
                              icon: Icon(passwordVisible? Icons.visibility: Icons.visibility_off,color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Por favor ingrese su contraseña';
                            }
                          },
                          onSaved: (String val) { _password = val; }
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(top: 50.0),
                          alignment: Alignment.center,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                  ),
                                  color: Colors.red,
                                  onPressed: () => {
                                    if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save(),
                                    _validateAndSubmit(context),
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
                                          child: Text( "REGISTRATE", textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                )
              ],
            ),
          ),
          FlatButton(
            child: Text('¿Ya tienes cuenta? Login'),
            onPressed: ()=> Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => Login())),
          ),  
        ],
      ),
    );
  }
  
  _validateAndSubmit(context) async {
    FirebaseUser user;
    try {
        user = await signUp(_email, _password);
        if(user!=null){
          UserUpdateInfo info = new UserUpdateInfo();
          info.displayName = _name +" " + _lastname;
          user.updateProfile(info);
          await user.reload();
          user = await FirebaseAuth.instance.currentUser();

          Firestore.instance.collection('users').document().setData({
            'name': _name + _lastname,
            'uid': user.uid,
            'email': user.email,

          });
          
          print(user.toString());
          helper.setID(user.uid);
          helper.setIsLogin(true);

          Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => MainHome()));
        }
    } catch (e) {
      print('Error: $e');
    }
  }

}

