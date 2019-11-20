import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/ordem_servicoIncluir.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';

class OrdemServico extends StatefulWidget {
  final int admin;
  OrdemServico(this.admin);
  @override
  _OrdemServicoState createState() => _OrdemServicoState(this.admin);
}

class _OrdemServicoState extends State<OrdemServico> {
  final int admin;
  _OrdemServicoState(this.admin);
  final format = DateFormat("dd/MM/yyyy");
  TextEditingController data = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ordens de Aluguel"),
          centerTitle: true,
          backgroundColor: Colors.grey,
          leading: Icon(Icons.assignment),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrdemServicoIncluir()));
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection("ordens").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return new Center(
                      child: CircularProgressIndicator(),
                    );
                  } else
                    return new ListView(
                      children: snapshot.data.documents.map((document) {
                        int status = document["status"];

                        return new Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(6),
                          child: ExpansionTile(
                            leading: status == 1
                                ? Icon(Icons.airport_shuttle)
                                : status == 2
                                    ? Icon(Icons.beenhere)
                                    : Icon(
                                        Icons.beenhere,
                                        color: Colors.green,
                                      ),
                            trailing: status == 1
                                ? Text(document["dataCriacao"])
                                : status == 2
                                    ? Text(document["data_entrega"])
                                    : Text(document["data_devolucao"]),
                            title: StreamBuilder<DocumentSnapshot>(
                              stream: Firestore.instance
                                  .collection("clientes")
                                  .document(document["clienteId"])
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot2) {
                                if (!snapshot2.hasData) {
                                  return new Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else
                                  return Text(
                                    "${snapshot2.data["nome"]}",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  );
                              },
                            ),
                            children: <Widget>[
                              StreamBuilder<DocumentSnapshot>(
                                stream: Firestore.instance
                                    .collection("equipamentos")
                                    .document(document["equipamentoId"])
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<DocumentSnapshot> snapshot2) {
                                  if (!snapshot2.hasData) {
                                    return new Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Equipamento: ${snapshot2.data["nome"]}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                              "Data Ciração da Ordem: ${document["dataCriacao"]}"),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          snapshot2.data["operador"] == false
                                              ? Text(
                                                  "Valor dia: R\$ ${snapshot2.data["valorDia"]} x ${document["dias"]} dias")
                                              : Text(
                                                  "Valor hora: R\$ ${snapshot2.data["valorHoraOperador"].toStringAsFixed(2)} x ${document["horasOperador"]} horas trabalhadas"),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                              "SubTotal: R\$ ${document["subtotal"].toStringAsFixed(2)}"),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Text(
                                              "Desconto: R\$ ${document["desconto"].toStringAsFixed(2)}"),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "Total: R\$ ${document["total"].toStringAsFixed(2)}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          SizedBox(
                                            height: 10.0,
                                          ),
                                          Text(
                                            "Status da Ordem:",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              _buildCircle(
                                                  "1", "Entrega", status, 1),
                                              Container(
                                                height: 1.0,
                                                width: 40.0,
                                                color: Colors.grey[500],
                                              ),
                                              _buildCircle(
                                                  "2", "Devolução", status, 2),
                                            ],
                                          ),
                                          status <= 2 && admin == 1
                                              ? RaisedButton(
                                                  child: Text(status == 1
                                                      ? "Confirmar Entrega"
                                                      : "Confirmar Devolução"),
                                                  textColor: Colors.white,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  onPressed: () {
                                                    int teste = status + 1;
                                                    if (teste == 2) {
                                                      Firestore.instance
                                                          .collection("ordens")
                                                          .document(document
                                                              .documentID)
                                                          .updateData({
                                                        "data_entrega": data
                                                                    .text !=
                                                                ""
                                                            ? data.text
                                                            : new DateFormat(
                                                                    "dd/MM/yyyy")
                                                                .format(DateTime
                                                                    .now()),
                                                      });
                                                    } else {
                                                      Firestore.instance
                                                          .collection("ordens")
                                                          .document(document
                                                              .documentID)
                                                          .updateData({
                                                        "data_devolucao": data
                                                                    .text !=
                                                                ""
                                                            ? data.text
                                                            : new DateFormat(
                                                                    "dd/MM/yyyy")
                                                                .format(DateTime
                                                                    .now()),
                                                      });
                                                    }
                                                    Firestore.instance
                                                        .collection("ordens")
                                                        .document(
                                                            document.documentID)
                                                        .updateData({
                                                      "status": teste,
                                                    });
                                                  },
                                                )
                                              : Container(
                                                  height: 10,
                                                ),
                                          status <= 2 && admin == 1
                                              ? DateTimeField(
                                                  controller: data,
                                                  decoration: InputDecoration(
                                                      labelText: status == 1
                                                          ? 'Data Entrega'
                                                          : 'Data Devolução',
                                                      hasFloatingPlaceholder:
                                                          false),
                                                  format: format,
                                                  //controller: dataCriacao,
                                                  onShowPicker:
                                                      (context, currentValue) {
                                                    return showDatePicker(
                                                        context: context,
                                                        firstDate:
                                                            DateTime(1900),
                                                        initialDate:
                                                            currentValue ??
                                                                DateTime.now(),
                                                        lastDate:
                                                            DateTime(2100));
                                                  },
                                                )
                                              : Container(
                                                  height: 10,
                                                ),
                                        ],
                                      ),
                                    );
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
      ),
    );
  }

  Widget _buildCircle(
      String title, String subtitle, int status, int thisStatus) {
    // para cada circulo
    Color backColor;
    Widget child;

    if (status < thisStatus) {
      backColor = Colors.grey[500];
      child = Text(
        title,
        style: TextStyle(color: Colors.white),
      );
    } else if (status == thisStatus) {
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(color: Colors.white),
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(
        Icons.check,
        color: Colors.white,
      );
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20.0,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle),
      ],
    );
  }
}
