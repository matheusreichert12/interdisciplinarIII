import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/criarconta.dart';
import 'package:interdisciplinar/inicialAdministrador.dart';
import 'package:interdisciplinar/inicialFuncionario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _login = TextEditingController();
  final _senha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        color: Colors.white,
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
              decoration: InputDecoration(
                labelText: "Login",
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
          ],
        ),
      ),
    );
  }

  verificaLogin() {
    //String id = "";
    Firestore.instance
        .collection("usuarios")
        .where("login", isEqualTo: _login.text)
        .where("senha", isEqualTo: _senha.text)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.length != 0) {
        // id = docs.documents[0].documentID;
        // tem usuario cadastrado
        if (docs.documents[0].data['admin'] == 1) {
          //administrador

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InicialAdministrador()));
        } else {
          //funcionario
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InicialFuncionario()));
        }
      } else {
        //não ta cadastrado
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text(
                "Usuário e/ou senha incorreta!",
                style: new TextStyle(color: Colors.red),
              ),
              actions: <Widget>[
                // define os botões na base do dialogo
                new FlatButton(
                  child: new Text("Fechar"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }
}
