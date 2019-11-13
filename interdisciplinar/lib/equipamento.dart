import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/equipamentoAlterar.dart';
import 'package:interdisciplinar/equipamentoIncluir.dart';

class Equipamento extends StatefulWidget {
  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<Equipamento> {
  TextEditingController filtro = TextEditingController();

  var campoFiltragem;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: filtro,
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              campoFiltragem = value;
            });
          },
          decoration: InputDecoration(
              hintText: "Pesquisar", hintStyle: TextStyle(color: Colors.white)),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: Icon(Icons.search),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection('equipamentos')
                  .orderBy("nome")
                  .startAt([campoFiltragem]).endAt(
                      [campoFiltragem + '\uf8ff']).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return new Center(
                    child: CircularProgressIndicator(),
                  );
                } else
                  return new ListView(
                    children: snapshot.data.documents.map((document) {
                      return new Card(
                        child: new Row(
                          children: <Widget>[
                            Expanded(
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EquipamentoAlterar(
                                                idEquipamento:
                                                    document.documentID,
                                              )));
                                },
                                leading: Icon(
                                  Icons.build,
                                  size: 30,
                                ),
                                title: Text(
                                  document['nome'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                subtitle: document['valorMes'] == 0
                                    ? Text("Valor diária: R\$" +
                                        document['valorDia'].toStringAsFixed(2))
                                    : Text("Valor diária: R\$" +
                                        document['valorDia']
                                            .toStringAsFixed(2) +
                                        " Valor ao Mês: R\$" +
                                        document['valorMes']
                                            .toStringAsFixed(2)),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                Firestore.instance
                                    .collection("equipamentos")
                                    .document(document.documentID)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EquipamentoIncluir()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
