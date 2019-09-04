import 'package:flutter/material.dart';

class InicialFuncionario extends StatefulWidget {
  @override
  _InicialFuncionarioState createState() => _InicialFuncionarioState();
}

class _InicialFuncionarioState extends State<InicialFuncionario> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página Funcionário"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
    );
  }
}
