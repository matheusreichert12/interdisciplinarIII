import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/contatosIncluir.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('clientes').snapshots(),
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
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              backgroundColor: Colors.grey),
                          title: Text(
                            document['nome'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(document['cidade'].toString() +
                              ", " +
                              document['endereco'].toString() +
                              ",  Tel.: " +
                              document['telefone'].toString()),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          Firestore.instance
                              .collection("clientes")
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
              MaterialPageRoute(builder: (context) => ContatosIncluir()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}