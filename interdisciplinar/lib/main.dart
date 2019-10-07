import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/login.dart';

void main() {
  /*Firestore.instance.collection("ordens").document().setData({
    "clienteID": "-LqCjxN8wtK2etO8cDZS",
    "equipamento": {
      "equipamentoID": "-LqCk1WyAUODo3ND4B4M",
      "valorDia": 170.0,
      "valorMes": 0.0,
      "nome": "Teste",
      "descricaoAdicional": "",
      "valorAdicional": 0.0
    },
    "desconto": 50.0,
    "data_entrega": "06/10/2019",
    "data_devolucao": "11/10/2019",
    "status": 1,
    "dias": 5,
    "valorEquipamentos": 850.0,
    "valorTotal": 800.0
  });*/

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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TMJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Login(),
    );
  }
}
