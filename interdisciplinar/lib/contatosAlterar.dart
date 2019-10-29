import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContatosAlterar extends StatefulWidget {
  final String idCliente;
  ContatosAlterar({this.idCliente});

  @override
  _ContatosAlterarState createState() =>
      _ContatosAlterarState(idCliente: this.idCliente);
}

class _ContatosAlterarState extends State<ContatosAlterar> {
  final String idCliente;
  _ContatosAlterarState({this.idCliente});

  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _endereco = TextEditingController();
  final _cidade = TextEditingController();
  final _telefone = TextEditingController();

  @override
  initState() {
    super.initState();
    // Add listeners to this class
    buscaDados();
  }

  buscaDados() {
    Firestore.instance
        .collection("clientes")
        .document(this.idCliente)
        .snapshots()
        .forEach((DocumentSnapshot docs) {
      if (docs.data.length != 0) {
        _nome.text = docs.data['nome'];
        _endereco.text = docs.data['endereco'];
        _cidade.text = docs.data['cidade'];
        _telefone.text = docs.data['telefone'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Alterar Cliente"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Coloque o Nome do Cliente';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  controller: _nome,
                  decoration: InputDecoration(
                    hintText: "Nome",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _endereco,
                  decoration: InputDecoration(
                    hintText: "Endereço",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _cidade,
                  decoration: InputDecoration(
                    hintText: "Cidade",
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _telefone,
                  decoration: InputDecoration(
                    hintText: "Telefone",
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 50,
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: SizedBox.expand(
                    child: FlatButton(
                      child: Text(
                        "Alterar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        alterarCliente();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void alterarCliente() {
    Firestore.instance.collection("clientes").document(this.idCliente).updateData({
      'nome': _nome.text,
      'endereco': _endereco.text,
      'cidade': _cidade.text,
      'telefone': _telefone.text,
    }).then((_) {
      Navigator.pop(context);
    });
  }
}
