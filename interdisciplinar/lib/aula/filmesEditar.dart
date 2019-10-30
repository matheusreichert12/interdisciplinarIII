import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FilmesEditar extends StatefulWidget {
  final String tipoEdicao;
  final DocumentSnapshot dadosFilme;

  FilmesEditar({this.tipoEdicao, this.dadosFilme});

  @override
  _FilmesEditarState createState() => _FilmesEditarState();
}

class _FilmesEditarState extends State<FilmesEditar> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController nomeFilme = TextEditingController();
  TextEditingController precoFilme = TextEditingController();
  TextEditingController idGenero = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.tipoEdicao == "alt") {
      nomeFilme.text = widget.dadosFilme.data["nomeFilme"].toString();
      precoFilme.text = widget.dadosFilme.data["precoFilme"].toString();
      idGenero.text = widget.dadosFilme.data["idGenero"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tipoEdicao == "alt"
            ? "Edição de Filmes"
            : "Inclusão de Filmes"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Form(
          key: formkey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nomeFilme,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Nome filme",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelStyle: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: precoFilme,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Preço filme",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelStyle: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: idGenero,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: "Gênero",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelStyle: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("Gravar"),
                onPressed: () {
                  if (widget.tipoEdicao == "alt") {
                    Firestore.instance
                        .collection("filmes")
                        .document(widget.dadosFilme.documentID)
                        .updateData({
                      "nomeFilme": nomeFilme.text,
                      "precoFilme": precoFilme.text,
                      "idGenero": idGenero.text
                    });
                  } else {
                    Firestore.instance.collection("filmes").add({
                      "nomeFilme": nomeFilme.text,
                      "precoFilme": precoFilme.text,
                      "idGenero": idGenero.text
                    });
                  }

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
