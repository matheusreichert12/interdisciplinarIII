import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:interdisciplinar/equipamentoAlterar.dart';

class ExamplePage extends StatefulWidget {
  // ExamplePage({ Key key }) : super(key: key);
  @override
  _ExamplePageState createState() => new _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  // final formKey = new GlobalKey<FormState>();
  // final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _filter = new TextEditingController();
  final dio = new Dio();
  String _searchText = "";
  List names = new List();
  List filteredNames = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Equipamentos');

  _ExamplePageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    this._getNames();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: Container(
        child: _buildList("T"),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList(String texto) {
    /*if (!(_searchText.isEmpty)) {
      List tempList = new List();
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]['name']
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
        }
      }
      filteredNames = tempList;
    }
    return ListView.builder(
      itemCount: names == null ? 0 : filteredNames.length,
      itemBuilder: (BuildContext context, int index) {
        return new ListTile(
          title: Text(filteredNames[index]['name']),
          onTap: () => print(filteredNames[index]['name']),
        );
      },
    );*/
    var queryResultSet = [];
    var tempSearchStore = [];

    if (texto.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }

    var capitalizedValue =
        texto.substring(0, 1).toUpperCase() + texto.substring(1);
  print(texto.substring(0, 1).toUpperCase());
    if (queryResultSet.length == 0 && texto.length == 1) {
        print(texto.substring(0, 1).toUpperCase());
      Firestore.instance
          .collection('equipamentos')
          .where('nome', isEqualTo: texto.substring(0, 1).toUpperCase())
          .getDocuments()
          .then((QuerySnapshot docs) {
        for (int i = 0; i < docs.documents.length; ++i) {
           print(texto.substring(0, 1).toUpperCase());
          queryResultSet.add(docs.documents[i].data);
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['nome'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
   
    return StreamBuilder(
        stream: Firestore.instance
            .collection('equipamentos')
            .where('nome', isEqualTo: texto.substring(0, 1).toUpperCase())
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Equipamentos');
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getNames() async {
    final response = await dio.get('https://swapi.co/api/people');
    List tempList = new List();
    for (int i = 0; i < response.data['results'].length; i++) {
      tempList.add(response.data['results'][i]);
    }
    setState(() {
      names = tempList;
      names.shuffle();
      filteredNames = names;
    });
  }
}
