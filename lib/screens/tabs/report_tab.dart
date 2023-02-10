import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart' as p;
import 'package:sumilao/widgets/text_widget.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportTab extends StatefulWidget {
  @override
  State<ReportTab> createState() => _ReportTabState();
}

class _ReportTabState extends State<ReportTab> {
  @override
  void initState() {
    super.initState();
    getData();
    getDataMonth();
  }

  var brgys = [
    'Kisolon',
    'Kulasi',
    'Lican',
    'Lupiagan',
    'Ocasion',
    'Poblacion',
    'San Roque',
    'San Vicente',
    'Vista Villa',
    'Puntian',
  ];

  var datas = [];
  var datasMonth = [];

  var hasLoaded = false;

  getData() async {
    for (int i = 0; i < brgys.length; i++) {
      var collection = FirebaseFirestore.instance
          .collection('Patient')
          .where('brgy', isEqualTo: brgys[i]);

      var querySnapshot = await collection.get();

      datas.add(querySnapshot.size);

      setState(() {});
    }
  }

  getDataMonth() async {
    for (int i = 0; i < 12; i++) {
      var collection = FirebaseFirestore.instance
          .collection('Patient')
          .where('month', isEqualTo: i + 1);

      var querySnapshot = await collection.get();

      datasMonth.add(querySnapshot.size);
    }

    setState(() {
      hasLoaded = true;
    });
  }

  List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "June",
    "July",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    print(datasMonth);
    final List<ChartData> chartData = [
      for (int i = 0; i < brgys.length; i++) ChartData(brgys[i], datas[i])
    ];

    Map<String, double> dataMap = {
      for (int i = 0; i < brgys.length; i++) brgys[i]: datas[i]
    };

    return hasLoaded
        ? Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      p.PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: 250,
                        colorList: const [
                          Colors.blue,
                          Colors.amber,
                          Colors.red,
                          Colors.green,
                          Colors.brown,
                        ],
                        initialAngleInDegree: 0,
                        chartType: p.ChartType.disc,
                        ringStrokeWidth: 32,

                        legendOptions: const p.LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: p.LegendPosition.right,
                          showLegends: true,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const p.ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: false,
                          showChartValuesInPercentage: false,
                          showChartValuesOutside: false,
                          decimalPlaces: 1,
                        ),
                        // gradientList: ---To add gradient colors---
                        // emptyColorGradient: ---Empty Color gradient---
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextBold(
                              text: 'Patient Records per Month',
                              fontSize: 18,
                              color: Colors.black),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                              width: 500,
                              child: SfCartesianChart(

                                  // Initialize category axis
                                  primaryXAxis: CategoryAxis(),
                                  series: <ChartSeries>[
                                    // Initialize line series
                                    LineSeries<ChartData1, String>(
                                        dataSource: [
                                          // Bind data source
                                          for (int i = 0;
                                              i < months.length;
                                              i++)
                                            ChartData1(
                                                months[i], datasMonth[i]),
                                        ],
                                        xValueMapper: (ChartData1 data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData1 data, _) =>
                                            data.y)
                                  ])),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                    child: Column(
                      children: [
                        TextBold(
                            text: 'Patient Records by Baranggay',
                            fontSize: 18,
                            color: Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                            child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                series: <ChartSeries<ChartData, String>>[
                              // Renders column chart
                              ColumnSeries<ChartData, String>(
                                  dataSource: chartData,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y)
                            ])),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class ChartData1 {
  ChartData1(this.x, this.y);
  final String x;
  final double? y;
}
