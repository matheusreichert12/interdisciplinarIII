import 'package:flutter/material.dart';
import 'package:interdisciplinar/criarconta.page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                  onPressed: () {},
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
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CriarContaPage())),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
