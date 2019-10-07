import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:interdisciplinar/contatos.dart';
import 'package:interdisciplinar/equipamento.dart';
import 'package:interdisciplinar/ordem_servico.dart';

class InicialAdministrador extends StatefulWidget {
  @override
  _InicialAdministradorState createState() => _InicialAdministradorState();
}

class _InicialAdministradorState extends State<InicialAdministrador> {
  int _pageIndex = 0;

  Widget _showPage = new Equipamento();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return new Equipamento();
        break;
      case 1:
        return new Container(
          child: new Contatos(),
        );
        break;
      case 2:
        return new Container(
          child: new OrdemServico(),
        );
        break;
      default:
        return new Container(
          child: new Text("Página não Encontrada"),
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
          Icon(Icons.group, size: 30, color: Colors.white),
          Icon(Icons.assignment, size: 30, color: Colors.white),
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
