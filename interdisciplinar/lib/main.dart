import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/criarconta.dart';
import 'package:interdisciplinar/esqueciSenha.dart';
import 'package:interdisciplinar/inicialAdministrador.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _login = TextEditingController();
  TextEditingController _senha = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        key: _scaffoldKey,
        body: Container(
          padding: EdgeInsets.only(
            top: 60,
            left: 40,
            right: 40,
          ),
          color: Colors.white,
          child: Form(
            key: formKey,
            child: ListView(
              children: <Widget>[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/tmj.png"),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _login,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite um E-mail";
                    } else if (!_login.text.contains("@")) {
                      return "Informe um E-mail válido";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: _senha,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Digite uma Senha";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: "Senha",
                    labelStyle: TextStyle(
                        color: Colors.black38,
                        fontWeight: FontWeight.w400,
                        fontSize: 20),
                  ),
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: FlatButton(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        verificaLogin();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 40,
                  child: FlatButton(
                    child: Text(
                      "Cadastre-se",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CriarConta()));
                    },
                  ),
                ),
                Container(
                  height: 40,
                  child: FlatButton(
                    child: Text(
                      "Recuperar Senha",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EsqueciSenha()));
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logar() async {
    loading();
    try {
      FirebaseUser usuario = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: _login.text, password: _senha.text);
      Navigator.pop(context);

      Firestore.instance
          .collection("usuarios")
          .where("idUsuario", isEqualTo: usuario.uid)
          .getDocuments()
          .then((QuerySnapshot docs) {
        if (docs.documents.length != 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicialAdministrador(docs.documents[0].data['admin'])));
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("E-mail não cadastrado!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ));
        }
      });
    } catch (erro) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Login ou senha inválidos!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }
  }

  verificaLogin() {
    //String id = "";

    if (formKey.currentState.validate()) {
      logar();
      /*Firestore.instance
          .collection("usuarios")
          .where("login", isEqualTo: _login.text)
          .where("senha", isEqualTo: _senha.text)
          .getDocuments()
          .then((QuerySnapshot docs) {
        if (docs.documents.length != 0) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      InicialAdministrador(docs.documents[0].data['admin'])));
        } else {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("Login ou senha inválidos!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          ));
        }
      });*/

    }
  }

  void loading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0),
          child: new Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            padding: EdgeInsets.all(10),
            height: 70,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                SizedBox(
                  width: 30,
                ),
                new Text(" Verificando ..."),
              ],
            ),
          ),
        );
      },
    );
  }
}
