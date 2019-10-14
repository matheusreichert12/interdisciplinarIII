import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/graficos.dart';
import 'package:interdisciplinar/ordem_servicoIncluir.dart';

class OrdemServico extends StatefulWidget {
  final int admin;
  OrdemServico(this.admin);
  @override
  _OrdemServicoState createState() => _OrdemServicoState(this.admin);
}

class _OrdemServicoState extends State<OrdemServico> {
  final int admin;
  _OrdemServicoState(this.admin);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Pesquisar por equipamento ou cliente",
              hintStyle: TextStyle(color: Colors.white),
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey,
          leading: Icon(Icons.search),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.assignment)),
              Tab(icon: Icon(Icons.insert_chart)),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OrdemServicoIncluir()));
          },
          child: Icon(Icons.add),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
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
                        margin: EdgeInsets.all(8),
                        child: ExpansionTile(
                          title: Text(
                            "${document["nomeCliente"]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700],
                            ),
                          ),
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Equipamento: ${document["equipamento"]["nome"]}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                      "Data Entrega: ${document["data_entrega"]}"),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                      "Valor dia: R\$ ${document["equipamento"]["valorDia"].toStringAsFixed(2)} x ${document["dias"]} dias"),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                      "SubTotal: R\$ ${document["valorEquipamentos"].toStringAsFixed(2)}"),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                      "Desconto: R\$ ${document["desconto"].toStringAsFixed(2)}"),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    "Total: R\$ ${document["valorTotal"].toStringAsFixed(2)}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 20.0,
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
                                      _buildCircle("1", "Entrega", status, 1),
                                      Container(
                                        height: 1.0,
                                        width: 40.0,
                                        color: Colors.grey[500],
                                      ),
                                      _buildCircle("2", "Devolução", status, 2),
                                    ],
                                  ),
                                  status <= 2 && admin == 1
                                      ? RaisedButton(
                                          child: Text(status == 1
                                              ? "Confirmar Entrega"
                                              : "Confirmar Devolução"),
                                          textColor: Colors.white,
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () {
                                            int teste = status + 1;
                                            Firestore.instance
                                                .collection("ordens")
                                                .document(document.documentID)
                                                .updateData({"status": teste});
                                          },
                                        )
                                      : Container(
                                          height: 10,
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
              },
            ),
            Graficos(),
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
