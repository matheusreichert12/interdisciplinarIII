import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EquipamentoAlterar extends StatefulWidget {
  final String idEquipamento;
  EquipamentoAlterar({this.idEquipamento});
  @override
  _EquipamentoAlterarState createState() =>
      _EquipamentoAlterarState(idEquipamento: this.idEquipamento);
}

class _EquipamentoAlterarState extends State<EquipamentoAlterar> {
  final String idEquipamento;
  _EquipamentoAlterarState({this.idEquipamento});
  bool _operador = false;
  @override
  initState() {
    buscaDados();
    super.initState();
    // Add listeners to this class
  }

  buscaDados() {
    Firestore.instance
        .collection("equipamentos")
        .document(this.idEquipamento)
        .snapshots()
        .forEach((DocumentSnapshot docs) {
      if (docs.data.length != 0) {
        _onChange(docs.data['operador']);
        _nome.text = docs.data['nome'];
        _valorDiaria.text = docs.data['valorDia'].toString();
        _valorMes.text = docs.data['valorMes'].toString();
        _horaOperador.text = docs.data['valorHoraOperador'].toString();
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _valorDiaria = TextEditingController();
  final _valorMes = TextEditingController();
  final _horaOperador = TextEditingController();

  void _onChange(bool value) {
    if (!mounted) return;
    setState(() {
      _operador = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Alteração Equipamento"),
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
                SwitchListTile(
                  title: Text("Contém operador"),
                  secondary: Icon(
                    Icons.person,
                    color: (_operador) ? Colors.green : Colors.grey,
                  ),
                  onChanged: (bool value) {
                    _onChange(value);
                  },
                  value: _operador,
                ),
                SizedBox(
                  height: 10,
                ),
                _operador == false
                    ? TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _valorDiaria,
                        decoration: InputDecoration(
                          hintText: "Valor diária",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _operador == false
                    ? TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _valorMes,
                        decoration: InputDecoration(
                          hintText: "Valor ao Mês",
                        ),
                      )
                    : SizedBox(
                        height: 0,
                      ),
                _operador == true
                    ? TextFormField(
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        controller: _horaOperador,
                        decoration: InputDecoration(
                          hintText: "Valor hora operador",
                        ),
                      )
                    : SizedBox(
                        height: 10,
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
                        "Alterar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          alterarEquipamento();
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

  void alterarEquipamento() {
    Firestore.instance
        .collection("equipamentos")
        .document(this.idEquipamento)
        .updateData({
      'nome': _nome.text.toUpperCase(),
      'valorDia': _valorDiaria.text == "" || _operador
          ? 0.0
          : double.parse(_valorDiaria.text.replaceAll(",", ".")),
      'valorMes': _valorMes.text == "" || _operador
          ? 0.0
          : double.parse(_valorMes.text.replaceAll(",", ".")),
      'valorHoraOperador': _horaOperador.text == "" || _operador == false
          ? 0.0
          : double.parse(_horaOperador.text.replaceAll(",", ".")),
      'operador': _operador,
    }).then((_) {
      Navigator.pop(context);
    });
  }
}
