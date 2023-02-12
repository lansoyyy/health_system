import 'dart:typed_data';
import 'package:pie_chart/pie_chart.dart' as p;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sumilao/services/local_storage.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/toast_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class PatientListTab extends StatefulWidget {
  @override
  State<PatientListTab> createState() => _PatientListTabState();
}

class _PatientListTabState extends State<PatientListTab> {
  @override
  void initState() {
    super.initState();
    getData();
    getDataMonth();
    getDataDiseases();
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

  var datasDisease = [];
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

  getDataDiseases() async {
    for (int i = 0; i < brgys.length; i++) {
      var collection = FirebaseFirestore.instance
          .collection('Patient')
          .where('brgy', isEqualTo: brgys[i]);

      var querySnapshot = await collection.get();

      datasDisease.add(querySnapshot.size);

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
  final ssController = ScreenshotController();
  var filters = ['name', 'address', 'gender'];

  final searchController = TextEditingController();

  var _dropValue = 0;

  String filter = 'name';

  String nameSearched = '';

  final doc = pw.Document();

  printing(Uint8List capturedImage) async {
    doc.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Container(
            height: double.infinity,
            width: double.infinity,
            child: pw.Image(
              pw.MemoryImage(capturedImage),
            ));
      },
    ));

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      for (int i = 0; i < brgys.length; i++) ChartData(brgys[i], datas[i])
    ];

    Map<String, double> dataMap = {
      for (int i = 0; i < brgys.length; i++) brgys[i]: datas[i]
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Screenshot(
                controller: ssController,
                child: TextBold(
                    text: 'Search Patient', fontSize: 18, color: Colors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 20),
                child: Container(
                  width: 1000,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 50,
                              width: 180,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: TextFormField(
                                onChanged: (value) {
                                  setState(() {
                                    nameSearched = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                    hintText: 'Search',
                                    hintStyle:
                                        TextStyle(fontFamily: 'QRegular'),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.grey,
                                    )),
                                controller: searchController,
                              ),
                            ),
                            const Expanded(child: SizedBox()),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, right: 10),
                              child: GestureDetector(
                                onTap: () {
                                  // To Implement
                                  // for (int i = 0; i < brgys.length; i++) {
                                  //   addPlaces(brgys[i]);
                                  // }

                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: SizedBox(
                                            width: 1000,
                                            height: 700,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    p.PieChart(
                                                      dataMap: dataMap,
                                                      animationDuration:
                                                          const Duration(
                                                              milliseconds:
                                                                  800),
                                                      chartLegendSpacing: 32,
                                                      chartRadius: 150,
                                                      colorList: const [
                                                        Colors.blue,
                                                        Colors.amber,
                                                        Colors.red,
                                                        Colors.green,
                                                        Colors.brown,
                                                      ],
                                                      initialAngleInDegree: 0,
                                                      chartType:
                                                          p.ChartType.disc,
                                                      ringStrokeWidth: 32,

                                                      legendOptions:
                                                          const p.LegendOptions(
                                                        showLegendsInRow: false,
                                                        legendPosition: p
                                                            .LegendPosition
                                                            .right,
                                                        showLegends: true,
                                                        legendTextStyle:
                                                            TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      chartValuesOptions: const p
                                                          .ChartValuesOptions(
                                                        showChartValueBackground:
                                                            true,
                                                        showChartValues: false,
                                                        showChartValuesInPercentage:
                                                            false,
                                                        showChartValuesOutside:
                                                            false,
                                                        decimalPlaces: 1,
                                                      ),
                                                      // gradientList: ---To add gradient colors---
                                                      // emptyColorGradient: ---Empty Color gradient---
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                            width: 450,
                                                            height: 220,
                                                            child:
                                                                SfCartesianChart(

                                                                    // Initialize category axis
                                                                    primaryXAxis:
                                                                        CategoryAxis(),
                                                                    series: <
                                                                        ChartSeries>[
                                                                  // Initialize line series
                                                                  LineSeries<
                                                                          ChartData1,
                                                                          String>(
                                                                      dataSource: [
                                                                        // Bind data source
                                                                        for (int i =
                                                                                0;
                                                                            i <
                                                                                months
                                                                                    .length;
                                                                            i++)
                                                                          ChartData1(
                                                                              months[i],
                                                                              datasMonth[i]),
                                                                      ],
                                                                      xValueMapper: (ChartData1 data,
                                                                              _) =>
                                                                          data
                                                                              .x,
                                                                      yValueMapper:
                                                                          (ChartData1 data, _) =>
                                                                              data.y)
                                                                ])),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 600,
                                                  width: 400,
                                                  child: GridView.builder(
                                                      itemCount: brgys.length,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  3),
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            TextBold(
                                                                text: brgys[
                                                                    index],
                                                                fontSize: 14,
                                                                color: Colors
                                                                    .black),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextRegular(
                                                                text:
                                                                    'No Disease: ',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextRegular(
                                                                text: 'Covid: ',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextRegular(
                                                                text:
                                                                    'Dengue: ',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                            TextRegular(
                                                                text:
                                                                    'Diarrhea: ',
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
                                                          ],
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  height: 50,
                                  width: 180,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.print,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextRegular(
                                            text: 'Print All Report',
                                            fontSize: 12,
                                            color: Colors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(color: Colors.grey)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: DropdownButton(
                                    dropdownColor: Colors.white,
                                    focusColor: Colors.white,
                                    value: _dropValue,
                                    items: [
                                      for (int i = 0; i < filters.length; i++)
                                        DropdownMenuItem(
                                          onTap: (() {
                                            filter = filters[i];
                                          }),
                                          value: i,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.layers_rounded,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextRegular(
                                                  text:
                                                      'Sort by: ${filters[i]}',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                    ],
                                    onChanged: ((value) {
                                      setState(() {
                                        _dropValue =
                                            int.parse(value.toString());
                                      });
                                    })),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                  stream: filter == 'name'
                      ? FirebaseFirestore.instance
                          .collection('Patient')
                          .where('name',
                              isGreaterThanOrEqualTo:
                                  toBeginningOfSentenceCase(nameSearched))
                          .where('name',
                              isLessThan:
                                  '${toBeginningOfSentenceCase(nameSearched)}z')
                          .orderBy(filter)
                          .snapshots()
                      : FirebaseFirestore.instance
                          .collection('Patient')
                          .where('name',
                              isGreaterThanOrEqualTo:
                                  toBeginningOfSentenceCase(nameSearched))
                          .where('name',
                              isLessThan:
                                  '${toBeginningOfSentenceCase(nameSearched)}z')
                          .orderBy('name')
                          .orderBy(filter)
                          .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print('error');

                      print(snapshot.error);

                      return const Center(child: Text('Error'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.black,
                        )),
                      );
                    }

                    final data = snapshot.requireData;
                    return DataTable(columns: [
                      DataColumn(
                          label: TextBold(
                              text: 'Patient Name',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Address',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Gender',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Disease',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: '', fontSize: 20, color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: '', fontSize: 20, color: Colors.black)),
                    ], rows: [
                      for (int i = 0; i < data.size; i++)
                        DataRow(cells: [
                          DataCell(TextRegular(
                              text: data.docs[i]['name'],
                              fontSize: 14,
                              color: Colors.grey)),
                          DataCell(TextRegular(
                              text: data.docs[i]['address'],
                              fontSize: 14,
                              color: Colors.grey)),
                          DataCell(TextRegular(
                              text: data.docs[i]['gender'],
                              fontSize: 14,
                              color: Colors.grey)),
                          DataCell(TextRegular(
                              text: data.docs[i]['disease'],
                              fontSize: 14,
                              color: Colors.grey)),
                          DataCell(ButtonWidget(
                              width: 75,
                              height: 40,
                              fontSize: 14,
                              label: 'Check',
                              onPressed: (() {
                                box.write('id', data.docs[i].id);
                                Navigator.pushNamed(context, '/patient');
                              }))),
                          DataCell(ButtonWidget(
                              color: Colors.red,
                              width: 75,
                              height: 40,
                              fontSize: 14,
                              label: 'Delete',
                              onPressed: (() async {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                            'Delete Confirmation',
                                            style: TextStyle(
                                                fontFamily: 'QBold',
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: const Text(
                                            'Are you sure you want to delete this patient?',
                                            style: TextStyle(
                                                fontFamily: 'QRegular'),
                                          ),
                                          actions: <Widget>[
                                            MaterialButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            MaterialButton(
                                              onPressed: () async {
                                                showToast(
                                                    'Patient deleted succesfully!');
                                                await FirebaseFirestore.instance
                                                    .collection('Patient')
                                                    .doc(data.docs[i].id)
                                                    .delete();
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Continue',
                                                style: TextStyle(
                                                    fontFamily: 'QRegular',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ));
                              }))),
                        ])
                    ]);
                  })
            ],
          ),
        ),
      ),
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
