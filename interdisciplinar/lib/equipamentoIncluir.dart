import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipamentoIncluir extends StatefulWidget {
  @override
  _EquipamentoIncluirState createState() => _EquipamentoIncluirState();
}

class _EquipamentoIncluirState extends State<EquipamentoIncluir> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _valorDiaria = TextEditingController();
  final _valorMes = TextEditingController();
  final _descricaoAdicional = TextEditingController();
  final _valorAdicional = TextEditingController();

  bool _operador = false;

  void _onChange(bool value) {
    setState(() {
      _operador = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipamento"),
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
                      return 'Coloque o Nome do Equipamento';
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
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorDiaria,
                  decoration: InputDecoration(
                    hintText: "Valor diária",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valorMes,
                  decoration: InputDecoration(
                    hintText: "Valor ao Mês",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SwitchListTile(
                  title: Text("Contém operador"),
                  secondary: Icon(
                    Icons.person,
                    color: (_operador == true) ? Colors.green : Colors.grey,
                  ),
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                  value: _operador,
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 5.0,
                  margin: EdgeInsets.zero,
                  child: ExpansionTile(
                    title: Text(
                      "Adicionais",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    leading: Icon(Icons.list),
                    trailing: Icon(Icons.add),
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _descricaoAdicional,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Descrição",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: TextFormField(
                          controller: _valorAdicional,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Valor",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
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
                        if (_formKey.currentState.validate()) {
                          salvarEquipamento();
                        }
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

  void salvarEquipamento() {
    Firestore.instance.collection("equipamentos").document().setData({
      'nome': _nome.text,
      'valorDia': _valorDiaria.text == "" ? 0 : double.parse(_valorDiaria.text),
      'valorMes': _valorMes.text == "" ? 0 : double.parse(_valorMes.text),
      'descricaoAdicional': _descricaoAdicional.text,
      'valorAdicional':
          _valorAdicional.text == "" ? 0 : double.parse(_valorAdicional.text),
    }).then((_) {
      Navigator.pop(context);
    });
  }
}
