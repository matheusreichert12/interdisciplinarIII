import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Equipamento extends StatefulWidget {
  @override
  _EquipamentoState createState() => _EquipamentoState();
}

class _EquipamentoState extends State<Equipamento> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('equipamento').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Text("Loading ...");
            }
            return new ListView(
              children: snapshot.data.documents.map((document) {
                return new Card(
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          onTap: () {
                            //updateAlertDialog(context, document.documentID);
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(document['equipamentoImage']),
                          ),
                          title: Text(
                            document['nome'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(document['descricao']),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
