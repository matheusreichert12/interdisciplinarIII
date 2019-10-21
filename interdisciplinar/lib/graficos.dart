import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class Graficos extends StatefulWidget {
  @override
  _GraficosState createState() => _GraficosState();
}

class _GraficosState extends State<Graficos> {
  @override
  Widget build(BuildContext context) {
    var data = [
      Gra('Jan', 10000),
      Gra('Fev', 25000),
      Gra('Mar', 30000),
      Gra('Abr', 8500),
      Gra('Mai', 8500),
      Gra('Jun', 8500),
      Gra('Jul', 8500),
      Gra('Ago', 8500),
      Gra('Set', 8500),
      Gra('Out', 8500),
      Gra('Nov', 8500),
      Gra('Dez', 8500),
    ];

    var series = [
      charts.Series(
          domainFn: (Gra sales, _) => sales.year,
          measureFn: (Gra sales, _) => sales.sales,
          id: 'Sales',
          data: data,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          labelAccessorFn: (Gra sales, _) =>
              'R\$${sales.sales.toStringAsFixed(2)}')
    ];

    var chart = charts.BarChart(
      series,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      vertical: false,
      /* behaviors: [

        new charts.DatumLegend(
          showMeasures: false,
          position: charts.BehaviorPosition.bottom,
          //outsideJustification: charts.OutsideJustification.endDrawArea,
          //horizontalFirst: false,
          desiredMaxRows: 7,
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black,
              fontFamily: 'Georgia',
              fontSize: 11),
        )
      ],*/
      animate: true,
      animationDuration: Duration(seconds: 1),
    );
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            child: chart,
            height: 500,
          ),
          Text(
            "Gráficos",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          RaisedButton(
            child: Text("Lucro Bruto ordens por mês"),
            onPressed: () {},
          ),
          Text(
            "Lucro Bruto total do Ano",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class Gra {
  final String year;
  final double sales;

  Gra(this.year, this.sales);
}

class Sales {
  final String day;
  final int sold;
  final charts.Color color;

  Sales(this.day, this.sold, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
