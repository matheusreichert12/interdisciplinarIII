import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ContatosIncluir extends StatefulWidget {
  @override
  _ContatosIncluirState createState() => _ContatosIncluirState();
}

class _ContatosIncluirState extends State<ContatosIncluir> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _endereco = TextEditingController();
  final _cidade = TextEditingController();
  final _telefone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Cadastrar Cliente"),
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
                        "Salvar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        salvarCliente();
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

  void salvarCliente() {
    Firestore.instance.collection("clientes").document().setData({
      'nome': _nome.text.toUpperCase(),
      'endereco': _endereco.text.toUpperCase(),
      'cidade': _cidade.text.toUpperCase(),
      'telefone': _telefone.text,
    }).then((_) {
      Navigator.pop(context);
    });
  }
}
