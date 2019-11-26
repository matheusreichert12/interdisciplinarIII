import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/main.dart';

class CriarConta extends StatefulWidget {
  @override
  _CriarContaState createState() => _CriarContaState();
}

class _CriarContaState extends State<CriarConta> {
  final _login = TextEditingController();
  final _senha = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                height: 20,
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
                      color: Colors.black,
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
                      color: Colors.black,
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
                  color: Colors.green[900],
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: SizedBox.expand(
                  child: FlatButton(
                    child: Text(
                      "Salvar",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        salvarConta();
                      }
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
                    "Ja possuí uma conta? Fazer login",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Home()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logar() async {
    loading();
    try {
      FirebaseUser usuario = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _login.text, password: _senha.text);

      Firestore.instance
          .collection("usuarios")
          .add({"idUsuario": usuario.uid, "admin": 0});

      Navigator.pop(context);
      Navigator.pop(context);
    } catch (erro) {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Erro ao Salvar!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }
  }

  salvarConta() {
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
