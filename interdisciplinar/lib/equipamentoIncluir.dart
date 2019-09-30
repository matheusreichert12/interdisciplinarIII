import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';

File image;

class EquipamentoIncluir extends StatefulWidget {
  @override
  _EquipamentoIncluirState createState() => _EquipamentoIncluirState();
}

class _EquipamentoIncluirState extends State<EquipamentoIncluir> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _descricao = TextEditingController();

  File image;

  Future pickerGallery() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image = img;
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
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: _descricao,
                  decoration: InputDecoration(
                    hintText: "Descrição",
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 200.0,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: image == null
                        ? Text('Nenhuma Imagem Selecionada')
                        : Image.file(image),
                  ),
                ),
                Divider(),
                Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.wallpaper,
                      size: 40,
                    ),
                    onPressed: pickerGallery,
                  ),
                ),
                SizedBox(
                  height: 5,
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
    var now = formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]);
    var fullImageName = _nome.text + '-$now' + '.jpg';
    var fullImageName2 = _nome.text + '-$now' + '.jpg';

    final StorageReference ref =
        FirebaseStorage.instance.ref().child(fullImageName);
    final StorageUploadTask task = ref.putFile(image);

    var parte1 =
        'https://firebasestorage.googleapis.com/v0/b/tmj-locadora-equipamentos.appspot.com/o/';
    var fullPathImage = parte1 + fullImageName2 + '?alt=media';

    Firestore.instance.collection("equipamento").document().setData({
      'nome': _nome.text,
      'descricao': _descricao.text,
      'equipamentoImage': '$fullPathImage'
    }).then((_) {
      Navigator.pop(context);
    });
  }
}