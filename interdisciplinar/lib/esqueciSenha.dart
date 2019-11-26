import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EsqueciSenha extends StatefulWidget {
  @override
  _EsqueciSenhaState createState() => _EsqueciSenhaState();
}

class _EsqueciSenhaState extends State<EsqueciSenha> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green[900],
        title: Text("Recuperar a Senha"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: userEmail,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Digite um E-mail";
                  } else if (!userEmail.text.contains("@")) {
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
                height: 5,
              ),
              Container(
                height: 50,
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
                      "Recuperar Senha",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        requisitar();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requisitar() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail.text);
      Navigator.pop(context);

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
                  new Text("Verifique seu e-mail"),
                  Padding(
                    padding: EdgeInsets.all(10),
                  ),
                  RaisedButton(
                    color: Colors.green,
                    child: Text("Fechar",style: TextStyle(color: Colors.white),),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (erro) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Erro ao verificar o E-mail!"),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ));
    }
  }
}
