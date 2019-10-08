import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrdemServico extends StatefulWidget {
  @override
  _OrdemServicoState createState() => _OrdemServicoState();
}

class _OrdemServicoState extends State<OrdemServico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("ordens").snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            //int status = snapshot.data["status"];

            /*return ListView(
              
              children: snapshot.data.documents.map((document) {
                return 
                Card(
                  elevation: 5.0,
                  margin: EdgeInsets.all(8),
                  child: ExpansionTile(
                    title: Text(
                      "${snapshot.data["nomeCliente"]} - 07/10/2019",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                    children: <Widget>[
                      Text(
                        "Código do Pedido: ${snapshot.data.documentID}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      //Text(_buildProductsText(snapshot.data)),
                      SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        "Status do Pedido:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 4.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      status <= 2
                          ? RaisedButton(
                              child: Text(status == 1
                                  ? "Confirmar Entrega"
                                  : "Confirmar Devolução"),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {},
                            )
                          : Container(
                              height: 10,
                            ),
                    ],
                  ),
                ),
              ),
            );*/
          }
        },
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
