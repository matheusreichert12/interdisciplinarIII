import 'package:flutter/material.dart';

class OrdemServicoIncluir extends StatefulWidget {
  @override
  _OrdemServicoIncluirState createState() => _OrdemServicoIncluirState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Gustavo'),
      Company(2, 'Matheus'),
    ];
  }
}

class Equip {
  int id;
  String name;

  Equip(this.id, this.name);

  static List<Equip> getequips() {
    return <Equip>[
      Equip(1, 'Compactador de solo'),
      Equip(2, 'Cortadora de piso'),
      Equip(3, 'Cortadora de parede'),
      Equip(4, 'Alisadora de piso'),
      Equip(5, 'Régua vibratória'),
      Equip(6, 'Placa vibratória'),
      Equip(7, 'Perfurador de solo'),
      Equip(8, 'Betorneira 120L'),
      Equip(9, 'Betorneira 250L'),
      Equip(10, 'Betorneira 400L'),
    ];
  }
}

class _OrdemServicoIncluirState extends State<OrdemServicoIncluir> {
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  List<Equip> _equipaments = Equip.getequips();
  List<DropdownMenuItem<Equip>> _dropdownMenuItemsEquip;
  Equip _selectedEquip;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;

    _dropdownMenuItemsEquip = buildDropdownMenuItemsEquip(_equipaments);
    _selectedEquip = _dropdownMenuItemsEquip[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Equip>> buildDropdownMenuItemsEquip(List companies) {
    List<DropdownMenuItem<Equip>> items = List();
    for (Equip company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  onChangeDropdownItem(Company selectedCompany) {
    setState(() {
      _selectedCompany = selectedCompany;
    });
  }

  onChangeDropdownItemEquip(Equip selectedCompany) {
    setState(() {
      _selectedEquip = selectedCompany;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ordem de Serviço"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text("Cliente:   "),
                    DropdownButton(
                      value: _selectedCompany,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Equipamento:   "),
                    DropdownButton(
                      value: _selectedEquip,
                      items: _dropdownMenuItemsEquip,
                      onChanged: onChangeDropdownItemEquip,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Quantidade de dias",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Valor diária: R\$80.00"),
                SizedBox(
                  height: 10,
                ),
                Text("Subtotal: R\$80.00"),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: "Desconto",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Valor Total: R\$80.00",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(
                  height: 10,
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
                        Navigator.of(context).pop();
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
}
