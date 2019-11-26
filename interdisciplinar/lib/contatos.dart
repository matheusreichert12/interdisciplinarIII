import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/contatosAlterar.dart';
import 'package:interdisciplinar/contatosIncluir.dart';
import 'package:url_launcher/url_launcher.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  TextEditingController filtro = TextEditingController();

  var campoFiltragem = "";

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
        backgroundColor: Colors.green[900],
        leading: Icon(Icons.search),
      ),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('clientes')
              .orderBy("nome")
              .startAt([campoFiltragem.toUpperCase()]).endAt(
                  [campoFiltragem.toUpperCase() + '\uf8ff']).snapshots(),
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
                                      builder: (context) => ContatosAlterar(
                                            idCliente: document.documentID,
                                          )));
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
                                document['endereco'].toString(),style: TextStyle(color: Colors.black),),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.phone,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            launch("tel:${document["telefone"]}");
                          },
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
        backgroundColor: Colors.green[900],
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ContatosIncluir()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
