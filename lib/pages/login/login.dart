import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:eat_app/utils/util.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eat_app/widgets/background.dart';
import 'package:eat_app/pages/home/home.dart';
import 'package:eat_app/utils/shared_helper.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool passwordVisible = false;
  bool _autoValidate = false;
  String _email,_password;
  SharedHelper helper;
  Future<FirebaseUser> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user;
  }

  @override
  void initState() {
    helper = new SharedHelper();
    passwordVisible = true;
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
                Text('Ingresa tus datos', style: TextStyle(fontSize: 20.0)),
                SizedBox( height: 60.0 ),
                Form(
                  key: _formKey,
                  autovalidate: _autoValidate,
                  child: Padding(
                    padding: EdgeInsets.only(left: 30.0,right: 30.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator:Utils.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            labelText: 'Correo electronico',
                            hintText: 'alguien@gmail.com',
                          ),
                          onSaved: (String val) { _email = val; }
                        ),
                        Padding(padding:EdgeInsets.only(top: 24)),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: passwordVisible,
                          decoration: InputDecoration(
                            labelText: 'Contraseña',
                            hintText: '***********',
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
                                          child: Text( "ACCEDER", textAlign: TextAlign.center,
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
            child: Text('Crear una nueva cuenta'),
            onPressed: ()=> Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => Register())),
          ),  
        ],
      ),
    );
  }
  
  _validateAndSubmit(context) async {
    FirebaseUser user;
    try {
        user = await signIn(_email, _password);
        if (user!=null) {
          print(user.toString());
          helper.setID(user.uid);
          helper.setIsLogin(true);
          Navigator.of(context).pushReplacement(new CupertinoPageRoute(builder: (BuildContext context) => MainHome()));
        }
          
    } catch (e) {
      Toast.show("Error al iniciar sesión", context);
      print('Error: $e');
    }
  }

}