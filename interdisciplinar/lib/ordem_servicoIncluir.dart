import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdemServicoIncluir extends StatefulWidget {
  @override
  _OrdemServicoIncluirState createState() => _OrdemServicoIncluirState();
}

class _OrdemServicoIncluirState extends State<OrdemServicoIncluir> {
  var _mySelectionCliente;
  var _mySelectionEquipamento;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Ordem de Serviço"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Cliente:   "),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('clientes').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Loading...');
                        return new DropdownButton<String>(
                          isDense: true,
                          hint: new Text("Selecione um cliente"),
                          value: _mySelectionCliente,
                          onChanged: (String newValue) {
                            setState(() {
                              _mySelectionCliente = newValue;
                            });
                          },
                          items: snapshot.data.documents.map((map) {
                            return new DropdownMenuItem<String>(
                              value: map["nome"].toString(),
                              child: new Text(
                                map["nome"],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Equipamento:   "),
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('equipamentos').snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) return const Text('Loading...');
                        return new DropdownButton<String>(
                          isDense: true,
                          hint: new Text("Selecione"),
                          value: _mySelectionEquipamento,
                          onChanged: (String newValue) {
                            setState(() {
                              _mySelectionEquipamento = newValue;
                            });
                          },
                          items: snapshot.data.documents.map((map) {
                            return new DropdownMenuItem<String>(
                              value: map["nome"].toString(),
                              child: new Text(
                                map["nome"],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Quantidade de dias",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Valor diária: R\$80.00"),
                SizedBox(
                  height: 10,
                ),
                Text("Subtotal: R\$80.00"),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Desconto",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Valor Total: R\$80.00",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                        Navigator.of(context).pop();
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
}
