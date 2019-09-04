import 'package:flutter/material.dart';

class InicialFuncionarioPage extends StatefulWidget {
  @override
  _InicialFuncionarioPageState createState() => _InicialFuncionarioPageState();
}

class _InicialFuncionarioPageState extends State<InicialFuncionarioPage> {
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
