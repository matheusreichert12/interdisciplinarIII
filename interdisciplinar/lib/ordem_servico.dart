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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) => EquipamentoIncluir()));*/
        },
        child: Icon(Icons.add),
      ),
      body: Card(
        elevation: 5.0,
        margin: EdgeInsets.all(8),
        child: ExpansionTile(
          title: Text(
            "Matheus Reichert - status: Entregou",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          children: <Widget>[
            StreamBuilder<DocumentSnapshot>(
              stream: Firestore.instance
                  .collection("ordens")
                  .document("-LqbNY5TUhZW7mxfrdnh")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  int status = snapshot.data["status"];
                  print(snapshot.data["status"]);
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Equipamento: ${snapshot.data["equipamento"]["nome"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text("Data Entrega: ${snapshot.data["data_entrega"]}"),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            "Valor dia: R\$ ${snapshot.data["equipamento"]["valorDia"].toStringAsFixed(2)} x ${snapshot.data["dias"]} dias"),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            "SubTotal: R\$ ${snapshot.data["valorEquipamentos"].toStringAsFixed(2)}"),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                            "Desconto: R\$ ${snapshot.data["desconto"].toStringAsFixed(2)}"),
                        SizedBox(
                          height: 4.0,
                        ),
                        SizedBox(
                          height: 4.0,
                        ),
                        Text(
                          "Total: R\$ ${snapshot.data["valorTotal"].toStringAsFixed(2)}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
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
                                onPressed: () {
                                  Firestore.instance
                                      .collection("ordens")
                                      .document("-LqbNY5TUhZW7mxfrdnh")
                                      .updateData({
                                    'clienteID': snapshot.data["clienteID"],
                                    'data_devolucao':
                                        snapshot.data["data_devolucao"],
                                    "equipamento": {
                                      "equipamentoID": "-LqCk1WyAUODo3ND4B4M",
                                      "valorDia": 170.0,
                                      "valorMes": 0.0,
                                      "nome": "Teste",
                                      "descricaoAdicional": "",
                                      "valorAdicional": 0.0
                                    },
                                    "desconto": 50.0,
                                    "data_entrega": "06/10/2019",
                                    "data_devolucao": "11/10/2019",
                                    "status": status++,
                                    "dias": 5,
                                    "valorEquipamentos": 850.0,
                                    "valorTotal": 800.0
                                  });
                                },
                              )
                            : Container(
                                height: 10,
                              ),
                      ],
                    ),
                  );
                }
              },
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
