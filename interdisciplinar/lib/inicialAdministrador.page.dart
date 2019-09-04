import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class InicialAdministradorPage extends StatefulWidget {
  @override
  _InicialAdministradorPageState createState() =>
      _InicialAdministradorPageState();
}

class _InicialAdministradorPageState extends State<InicialAdministradorPage> {
  int _pageIndex = 0;

  Widget _showPage = new Container(child: new Text("Equipamentos"));

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return new Container(
          child: new Text("Equipamentos"),
        );
        break;
      case 1:
        return new Container(
          child: new Text("Serviços"),
        );
        break;
      default:
        return new Container(
          child: new Text("Clientes"),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CurvedNavigationBar(
        initialIndex: _pageIndex,
        items: <Widget>[
          Icon(Icons.build, size: 30, color: Colors.white),
          Icon(Icons.assignment, size: 30, color: Colors.white),
          Icon(Icons.group, size: 30, color: Colors.white),
        ],
        color: Colors.grey,
        backgroundColor: Colors.white,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 700),
        onTap: (int tappedIndex) {
          setState(() {
            _showPage = _pageChooser(tappedIndex);
          });
        },
      ),
      body: Container(
        child: Center(
          child: _showPage,
        ),
      ),
    );
  }
}
