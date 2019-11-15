import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdemServicoIncluir extends StatefulWidget {
  @override
  _OrdemServicoIncluirState createState() => _OrdemServicoIncluirState();
}

class _OrdemServicoIncluirState extends State<OrdemServicoIncluir> {
  var _mySelectionCliente;
  var _mySelectionEquipamento;
  bool _operador = false;
  double _valorHora = 0;
  double _valorDia = 0;
  double _subtotal = 0;
  double _total = 0;
  TextEditingController quantDias = TextEditingController();
  TextEditingController quantHoras = TextEditingController();
  TextEditingController desconto = TextEditingController();

  void _onChange(bool value, double valor, double valorDia) {
    if (!mounted) return;
    setState(() {
      _operador = value;
      _valorHora = valor;
      _valorDia = valorDia;
    });
  }

  buscaDados(String idEquipamento) {
    Firestore.instance
        .collection("equipamentos")
        .document(idEquipamento)
        .snapshots()
        .forEach((DocumentSnapshot docs) {
      if (docs.data.length != 0) {
        _onChange(docs.data['operador'], docs.data['valorHoraOperador'],
            docs.data['valorDia']);
      }
    });
  }

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
                              value: map.documentID,
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
                      stream: Firestore.instance
                          .collection('equipamentos')
                          .snapshots(),
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
                              buscaDados(_mySelectionEquipamento);
                            });
                          },
                          items: snapshot.data.documents.map((map) {
                            return new DropdownMenuItem<String>(
                              value: map.documentID,
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
                SwitchListTile(
                  title: Text("Contém operador"),
                  secondary: Icon(
                    Icons.person,
                    color: (_operador) ? Colors.green : Colors.grey,
                  ),
                  onChanged: (bool value) {},
                  value: _operador,
                ),
                SizedBox(
                  height: 10,
                ),
                _operador
                    ? TextFormField(
                        controller: quantHoras,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Quantidade de horas",
                        ),
                        onFieldSubmitted: (value) {
                          double valu =
                              double.parse(value.replaceAll(",", "."));
                          double subtotal = valu * _valorHora;
                          double total = desconto.text == ""
                              ? subtotal
                              : subtotal -
                                  double.parse(
                                      desconto.text.replaceAll(",", "."));
                          setState(() {
                            _subtotal = subtotal;
                            _total = total;
                          });
                        },
                      )
                    : TextFormField(
                        onFieldSubmitted: (value) {
                          double valu =
                              double.parse(value.replaceAll(",", "."));
                          double subtotal = valu * _valorDia;
                          double total = desconto.text == ""
                              ? subtotal
                              : subtotal -
                                  double.parse(
                                      desconto.text.replaceAll(",", "."));
                          setState(() {
                            _subtotal = subtotal;
                            _total = total;
                          });
                        },
                        controller: quantDias,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Quantidade de dias",
                        ),
                      ),
                SizedBox(
                  height: 10,
                ),
                _operador
                    ? Text("Valor hora operador: R\$ ${_valorHora}")
                    : Text("Valor diária: R\$ ${_valorDia}"),
                SizedBox(
                  height: 10,
                ),
                Text("Subtotal: R\$ ${_subtotal}"),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: desconto,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Desconto",
                  ),
                  onFieldSubmitted: (value) {
                    double valu = double.parse(value.replaceAll(",", "."));
                    double total = _subtotal - valu;
                    setState(() {
                      _total = total;
                    });
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Valor Total: R\$ ${_total}",
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
                        print(_mySelectionEquipamento);
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
