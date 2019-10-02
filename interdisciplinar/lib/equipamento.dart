import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/equipamentoAlterar.dart';
import 'package:interdisciplinar/equipamentoIncluir.dart';

class Equipamento extends StatefulWidget {
  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<Equipamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipamentos"),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('equipamentos').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                      builder: (context) => EquipamentoAlterar(
                                            idEquipamento: document.documentID,
                                          )));
                            },
                            leading: Icon(
                              Icons.build,
                              size: 30,
                            ),
                            title: Text(
                              document['nome'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            subtitle: document['valorMes'] == 0
                                ? Text("Valor diária: R\$" +
                                    document['valorDia'].toStringAsFixed(2))
                                : Text("Valor diária: R\$" +
                                    document['valorDia'].toStringAsFixed(2) +
                                    " Valor ao Mês: R\$" +
                                    document['valorMes'].toStringAsFixed(2)),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => EquipamentoIncluir()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
