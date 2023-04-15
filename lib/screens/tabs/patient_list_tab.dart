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
import 'package:pdf/pdf.dart';

class PatientListTab extends StatefulWidget {
  const PatientListTab({super.key});

  @override
  State<PatientListTab> createState() => _PatientListTabState();
}

class _PatientListTabState extends State<PatientListTab> {
  @override
  void initState() {
    super.initState();
    // getData();
    // getDataMonth();
    // getDataDiseases();
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

  var diseases = ['All', 'No Sickness', 'Covid', 'Dengue', 'Diarrhea'];

  var disease = 'All';

  var datas = [];
  var datasMonth = [];

  var datasNoDiseas = [];
  var datasCovid = [];
  var dataDengue = [];
  var datasDiarrhea = [];
  var hasLoaded = false;

  // getData() async {
  //   for (int i = 0; i < brgys.length; i++) {
  //     var collection = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('brgy', isEqualTo: brgys[i]);

  //     var querySnapshot = await collection.get();

  //     datas.add(querySnapshot.size);
  //   }
  // }

  // getDataDiseases() async {
  //   for (int i = 0; i < brgys.length; i++) {
  //     var collection = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('brgy', isEqualTo: brgys[i])
  //         .where('disease', isEqualTo: 'No Disease');

  //     var querySnapshot = await collection.get();

  //     datasNoDiseas.add(querySnapshot.size);

  //     var collection1 = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('brgy', isEqualTo: brgys[i])
  //         .where('disease', isEqualTo: 'Covid');

  //     var querySnapshot1 = await collection1.get();

  //     datasCovid.add(querySnapshot1.size);

  //     var collection2 = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('brgy', isEqualTo: brgys[i])
  //         .where('disease', isEqualTo: 'Dengue');

  //     var querySnapshot2 = await collection2.get();

  //     dataDengue.add(querySnapshot2.size);

  //     var collection3 = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('brgy', isEqualTo: brgys[i])
  //         .where('disease', isEqualTo: 'Diarrhea');

  //     var querySnapshot3 = await collection3.get();

  //     datasDiarrhea.add(querySnapshot3.size);
  //   }
  //   setState(() {
  //     hasLoaded = true;
  //   });
  // }

  // getDataMonth() async {
  //   for (int i = 0; i < 12; i++) {
  //     var collection = FirebaseFirestore.instance
  //         .collection('Patient')
  //         .where('month', isEqualTo: i + 1);

  //     var querySnapshot = await collection.get();

  //     datasMonth.add(querySnapshot.size);
  //     setState(() {
  //       hasLoaded = true;
  //     });
  //   }
  // }

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
  var filters = ['name', 'address', 'brgy'];
  var filterLabel = ['Name', 'Address', 'Baranggay'];

  final searchController = TextEditingController();

  var _dropValue = 0;
  final _dropValue5 = 0;

  String filter = 'name';

  var _dropValue1 = 0;

  String gender = '';

  String nameSearched = '';

  final doc = pw.Document();

  List<String> names = [];
  List<String> addresses = [];
  List<String> sexs = [];
  List<String> dise = [];
  List<bool> actives = [];

  String cdate2 = DateFormat("MMMM, dd, yyyy").format(DateTime.now());

  void _createPdf() async {
    /// for using an image from assets
    // final image = await imageFromAssetBundle('assets/image.png');

    final image = await imageFromAssetBundle('assets/images/logo.jpg');

    doc.addPage(
      pw.Page(
        build: ((context) {
          return pw.Column(children: [
            pw.Center(
              child: pw.Image(image, height: 120, width: 120),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Sumilao, Bukidnon'),
            pw.SizedBox(height: 5),
            pw.Text(cdate2),
            pw.SizedBox(height: 20),
            pw.Text('Patient List'),
            pw.SizedBox(height: 30),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    pw.Text('Patient Name'),
                    pw.Text('Address'),
                    pw.Text('Sex'),
                    pw.Text('Disease'),
                    pw.Text('Disease Active'),
                  ],
                ),
                for (int i = 0; i < names.length; i++)
                  pw.TableRow(
                    children: [
                      pw.Text(names[i]),
                      pw.Text(addresses[i]),
                      pw.Text(sexs[i]),
                      pw.Text(dise[i]),
                      pw.Text(actives[i].toString()),
                    ],
                  ),
              ],
            ),
            pw.SizedBox(height: 75),
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.SizedBox(height: 5),
                  pw.Text(
                    'Signature over printed name',
                  ),
                ],
              ),
            ),
          ]);
        }),
        pageFormat: PdfPageFormat.a4,
      ),
    ); // Page

    /// print the document using the iOS or Android print service:
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());

    /// share the document to other applications:

    /// tutorial for using path_provider: https://www.youtube.com/watch?v=fJtFDrjEvE8
    /// save PDF with Flutter library "path_provider":
  }

  List genderLabels = ['Male', 'Female', 'Others'];

  int filterData = 0;
  int filterMonth = 0;

  filterStream() {
    if (filter != 'name') {
      return FirebaseFirestore.instance
          .collection('Patient')
          .orderBy(filter)
          .snapshots();
    } else if (gender != '') {
      return FirebaseFirestore.instance
          .collection('Patient')
          .where('name',
              isGreaterThanOrEqualTo: toBeginningOfSentenceCase(nameSearched))
          .where('name',
              isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
          .where('gender', isEqualTo: gender)
          .snapshots();
    } else if (filterMonth != 0 && filterData != 0) {
      return FirebaseFirestore.instance
          .collection('Patient')
          .where('name',
              isGreaterThanOrEqualTo: toBeginningOfSentenceCase(nameSearched))
          .where('name',
              isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
          .where('day', isEqualTo: filterData)
          .where('month', isEqualTo: filterMonth)
          .snapshots();
    } else if (disease != 'All') {
      return FirebaseFirestore.instance
          .collection('Patient')
          .where('name',
              isGreaterThanOrEqualTo: toBeginningOfSentenceCase(nameSearched))
          .where('name',
              isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
          .where('disease', isEqualTo: disease)
          .snapshots();
    } else {
      return FirebaseFirestore.instance
          .collection('Patient')
          .where('name',
              isGreaterThanOrEqualTo: toBeginningOfSentenceCase(nameSearched))
          .where('name',
              isLessThan: '${toBeginningOfSentenceCase(nameSearched)}z')
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, double> dataMap = {
    //   for (int i = 0; i < brgys.length; i++) brgys[i]: datas[i]
    // };

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 0),
                child: SizedBox(
                  width: 1100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      TextBold(
                          text: 'Search Patient',
                          fontSize: 18,
                          color: Colors.black),
                      IconButton(
                          onPressed: (() {
                            {
                              // showDialog(
                              //     context: context,
                              //     builder: (context) {
                              //       return Dialog(
                              //         child: Screenshot(
                              //           controller: ssController,
                              //           child: SizedBox(
                              //               width: 1000,
                              //               height: 700,
                              //               child: Row(
                              //                 mainAxisAlignment:
                              //                     MainAxisAlignment
                              //                         .spaceEvenly,
                              //                 crossAxisAlignment:
                              //                     CrossAxisAlignment
                              //                         .center,
                              //                 children: [
                              //                   Column(
                              //                     crossAxisAlignment:
                              //                         CrossAxisAlignment
                              //                             .start,
                              //                     children: [
                              //                       p.PieChart(
                              //                         dataMap: dataMap,
                              //                         animationDuration:
                              //                             const Duration(
                              //                                 milliseconds:
                              //                                     800),
                              //                         chartLegendSpacing:
                              //                             32,
                              //                         chartRadius: 150,
                              //                         colorList: const [
                              //                           Colors.blue,
                              //                           Colors.amber,
                              //                           Colors.red,
                              //                           Colors.green,
                              //                           Colors.brown,
                              //                         ],
                              //                         initialAngleInDegree:
                              //                             0,
                              //                         chartType: p
                              //                             .ChartType.disc,
                              //                         ringStrokeWidth: 32,

                              //                         legendOptions: const p
                              //                             .LegendOptions(
                              //                           showLegendsInRow:
                              //                               false,
                              //                           legendPosition: p
                              //                               .LegendPosition
                              //                               .right,
                              //                           showLegends: true,
                              //                           legendTextStyle:
                              //                               TextStyle(
                              //                             fontWeight:
                              //                                 FontWeight
                              //                                     .bold,
                              //                           ),
                              //                         ),
                              //                         chartValuesOptions:
                              //                             const p
                              //                                 .ChartValuesOptions(
                              //                           showChartValueBackground:
                              //                               true,
                              //                           showChartValues:
                              //                               false,
                              //                           showChartValuesInPercentage:
                              //                               false,
                              //                           showChartValuesOutside:
                              //                               false,
                              //                           decimalPlaces: 1,
                              //                         ),
                              //                         // gradientList: ---To add gradient colors---
                              //                         // emptyColorGradient: ---Empty Color gradient---
                              //                       ),
                              //                       Column(
                              //                         crossAxisAlignment:
                              //                             CrossAxisAlignment
                              //                                 .center,
                              //                         children: [
                              //                           SizedBox(
                              //                               width: 450,
                              //                               height: 220,
                              //                               child: SfCartesianChart(

                              //                                   // Initialize category axis
                              //                                   primaryXAxis: CategoryAxis(),
                              //                                   series: <ChartSeries>[
                              //                                     // Initialize line series
                              //                                     LineSeries<ChartData1,
                              //                                             String>(
                              //                                         dataSource: [
                              //                                           // Bind data source
                              //                                           for (int i = 0; i < months.length; i++)
                              //                                             ChartData1(months[i], datasMonth[i]),
                              //                                         ],
                              //                                         xValueMapper: (ChartData1 data, _) =>
                              //                                             data.x,
                              //                                         yValueMapper: (ChartData1 data, _) => data.y)
                              //                                   ])),
                              //                         ],
                              //                       )
                              //                     ],
                              //                   ),
                              //                   SizedBox(
                              //                     height: 600,
                              //                     width: 400,
                              //                     child: GridView.builder(
                              //                         itemCount:
                              //                             brgys.length,
                              //                         gridDelegate:
                              //                             const SliverGridDelegateWithFixedCrossAxisCount(
                              //                                 crossAxisCount:
                              //                                     3),
                              //                         itemBuilder:
                              //                             (context,
                              //                                 index) {
                              //                           return Column(
                              //                             mainAxisAlignment:
                              //                                 MainAxisAlignment
                              //                                     .center,
                              //                             crossAxisAlignment:
                              //                                 CrossAxisAlignment
                              //                                     .start,
                              //                             children: [
                              //                               TextBold(
                              //                                   text: brgys[
                              //                                       index],
                              //                                   fontSize:
                              //                                       14,
                              //                                   color: Colors
                              //                                       .black),
                              //                               const SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               TextRegular(
                              //                                   text:
                              //                                       'No Disease: ${datasNoDiseas[index]}',
                              //                                   fontSize:
                              //                                       12,
                              //                                   color: Colors
                              //                                       .grey),
                              //                               const SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               TextRegular(
                              //                                   text:
                              //                                       'Covid:  ${datasCovid[index]}',
                              //                                   fontSize:
                              //                                       12,
                              //                                   color: Colors
                              //                                       .grey),
                              //                               const SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               TextRegular(
                              //                                   text:
                              //                                       'Dengue:  ${dataDengue[index]}',
                              //                                   fontSize:
                              //                                       12,
                              //                                   color: Colors
                              //                                       .grey),
                              //                               const SizedBox(
                              //                                 height: 10,
                              //                               ),
                              //                               TextRegular(
                              //                                   text:
                              //                                       'Diarrhea:  ${datasDiarrhea[index]}',
                              //                                   fontSize:
                              //                                       12,
                              //                                   color: Colors
                              //                                       .grey),
                              //                             ],
                              //                           );
                              //                         }),
                              //                   ),
                              //                 ],
                              //               )),
                              //         ),
                              //       );
                              //     });

                              // To Implement
                              // for (int i = 0; i < brgys.length; i++) {
                              //   addPlaces(brgys[i]);
                              // }
                              _createPdf();
                            }
                          }),
                          icon: const Icon(
                            Icons.print_outlined,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 20),
                child: Container(
                  width: 1100,
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
                            // Container(
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(5),
                            //       color: Colors.white,
                            //       border: Border.all(color: Colors.grey)),
                            //   child: Padding(
                            //     padding: const EdgeInsets.fromLTRB(
                            //         20, 0, 20, 0),
                            //     child: DropdownButton(
                            //         dropdownColor: Colors.white,
                            //         focusColor: Colors.white,
                            //         value: _dropValue5,
                            //         items: [
                            //           for (int i = 0;
                            //               i < diseases.length;
                            //               i++)
                            //             DropdownMenuItem(
                            //               onTap: (() {
                            //                 disease = diseases[i];
                            //               }),
                            //               value: i,
                            //               child: TextRegular(
                            //                   text: diseases[i],
                            //                   fontSize: 14,
                            //                   color: Colors.grey),
                            //             ),
                            //         ],
                            //         onChanged: ((value) {
                            //           setState(() {
                            //             _dropValue5 =
                            //                 int.parse(value.toString());
                            //           });
                            //         })),
                            //   ),
                            // ),
                            // const SizedBox(
                            //   width: 10,
                            // ),
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
                                          child: TextRegular(
                                              text:
                                                  'Sort by: ${filterLabel[i]}',
                                              fontSize: 14,
                                              color: Colors.grey),
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
                            const SizedBox(
                              width: 10,
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
                                    value: _dropValue1,
                                    items: [
                                      for (int i = 0;
                                          i < genderLabels.length;
                                          i++)
                                        DropdownMenuItem(
                                          onTap: (() {
                                            gender = genderLabels[i];
                                          }),
                                          value: i,
                                          child: Row(
                                            children: [
                                              TextRegular(
                                                  text:
                                                      'Filter by: ${genderLabels[i]}',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                    ],
                                    onChanged: ((value) {
                                      setState(() {
                                        _dropValue1 =
                                            int.parse(value.toString());
                                      });
                                    })),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: (() async {
                                setState(() {
                                  gender = '';
                                  filter = 'name';
                                });
                                final DateTime? selectedDate =
                                    await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1900),
                                  lastDate: DateTime(2100),
                                );

                                if (selectedDate != null) {
                                  setState(() {
                                    filterData = selectedDate.day;
                                    filterMonth = selectedDate.month;
                                  });
                                }
                              }),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey)),
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        20, 15, 20, 15),
                                    child: TextRegular(
                                        text:
                                            'Date: $filterData/$filterMonth/2023',
                                        fontSize: 14,
                                        color: Colors.grey)),
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
                  stream: filterStream(),
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
                      DataColumn(label: Builder(builder: (context) {
                        return TextBold(
                            text: 'Patient Name',
                            fontSize: 18,
                            color: Colors.black);
                      })),
                      DataColumn(
                          label: TextBold(
                              text: 'Address',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Sex', fontSize: 18, color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Disease',
                              fontSize: 18,
                              color: Colors.black)),
                      DataColumn(
                          label: TextBold(
                              text: 'Active',
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
                          DataCell(Builder(builder: (context) {
                            names.clear();
                            addresses.clear();
                            sexs.clear();
                            dise.clear();
                            actives.clear();
                            names.add(data.docs[i]['name']);
                            addresses.add(data.docs[i]['address']);
                            dise.add(data.docs[i]['disease']);
                            sexs.add(data.docs[i]['gender']);
                            actives.add(data.docs[i]['isActive']);
                            return TextRegular(
                                text: data.docs[i]['name'],
                                fontSize: 14,
                                color: Colors.grey);
                          })),
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
                          DataCell(TextRegular(
                              text: data.docs[i]['isActive'].toString(),
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
                                print(data.docs[i]['brgy']);
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
                                                int num = 0;

                                                var collection =
                                                    FirebaseFirestore.instance
                                                        .collection('Places')
                                                        .where('place',
                                                            isEqualTo:
                                                                data.docs[i]
                                                                    ['brgy']);

                                                var querySnapshot =
                                                    await collection.get();
                                                if (mounted) {
                                                  setState(() {
                                                    for (var queryDocumentSnapshot
                                                        in querySnapshot.docs) {
                                                      Map<String, dynamic>
                                                          data =
                                                          queryDocumentSnapshot
                                                              .data();
                                                      num = data['nums'];
                                                    }
                                                  });
                                                }

                                                showToast(
                                                    'Patient deleted succesfully!');
                                                await FirebaseFirestore.instance
                                                    .collection('Patient')
                                                    .doc(data.docs[i].id)
                                                    .delete();

                                                await FirebaseFirestore.instance
                                                    .collection('Places')
                                                    .doc(data.docs[i]['brgy'])
                                                    .update({'nums': num - 1});

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
