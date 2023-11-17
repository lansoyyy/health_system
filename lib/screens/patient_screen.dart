import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/appbar_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final ssController = ScreenshotController();

  final notesController = TextEditingController();

  final box = GetStorage();

  final doc = pw.Document();

  late var userData1;

  printing() async {
    final image = await imageFromAssetBundle('assets/images/logo.jpg');
    doc.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Center(
            child: pw.Image(image, height: 80, width: 80),
          ),
          pw.Column(children: [
            pw.SizedBox(height: 20),
            pw.Text('Rural Health Unit',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.Text('Municipality of Sumilao',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.Text('Province of Bukidnon',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 5),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('Personal Information Sheet',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 11)),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(userData1['name'],
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
            pw.Divider(),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Full Name',
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.normal, fontSize: 10)),
                ]),
            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text(userData1['dateOfBirth'],
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            ),
            pw.Divider(),
            pw.Align(
              alignment: pw.Alignment.bottomLeft,
              child: pw.Text('Date of Birth (DD/MM/yyyy)',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10)),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(children: [
                    pw.Text('Sex:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10)),
                    pw.SizedBox(width: 5),
                    pw.Text(
                      userData1['gender'],
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.Text('Phone Number:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10)),
                    pw.SizedBox(width: 5),
                    pw.Text(
                      userData1['phoneNumber'],
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline),
                    ),
                  ]),
                  pw.SizedBox()
                ]),
            pw.SizedBox(height: 20),
            pw.Row(children: [
              pw.Text('Address:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10)),
              pw.SizedBox(width: 5),
              pw.Text(
                userData1['address'],
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline),
              ),
            ]),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(children: [
                    pw.Text('Medical Findings:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10)),
                    pw.SizedBox(width: 5),
                    pw.Text(
                      userData1['disease'],
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.Text('Date of Findings:',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal, fontSize: 10)),
                    pw.SizedBox(width: 5),
                    pw.Text(
                      userData1['dateOfFindings'],
                      style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline),
                    ),
                  ]),
                  pw.SizedBox()
                ]),
            pw.SizedBox(height: 50),
            pw.Row(children: [
              pw.Text('Notes:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10)),
              pw.SizedBox(width: 5),
              pw.Text(
                userData1['medicalFindings'][0]['notes'],
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline),
              ),
            ]),
            pw.SizedBox(height: 30),
            pw.Row(children: [
              pw.Text('Assited by:',
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.normal, fontSize: 10)),
              pw.SizedBox(width: 5),
              pw.Text(
                userData1['assistedBy'],
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    decoration: pw.TextDecoration.underline),
              ),
            ]),
          ]),
        ]);
      },
    ));

    await Printing.layoutPdf(onLayout: (format) async => doc.save());
  }

  final ageController = TextEditingController();

  final addressController = TextEditingController();

  final zoneController = TextEditingController();

  final brgyController = TextEditingController();

  final contactNumController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userData = FirebaseFirestore.instance
        .collection('Patient')
        .doc(box.read('id'))
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
        stream: userData,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          dynamic data = snapshot.data;
          return Screenshot(
            controller: ssController,
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.jpg',
                              height: 100,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            TextBold(
                                text: 'GeoFinds', fontSize: 24, color: primary),
                          ],
                        ),
                        TextBold(
                            text: 'PATIENT PROFILE',
                            fontSize: 58,
                            color: Colors.black),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                    customAppbar('Patient Profile'),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Container(
                        width: 900,
                        height: 275,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  box.read('user') != 'Nurse'
                                      ? GestureDetector(
                                          onTap: (() async {
                                            await FirebaseFirestore.instance
                                                .collection('Patient')
                                                .doc(box.read('id'))
                                                .update({
                                              'medicalFindings':
                                                  FieldValue.arrayUnion([
                                                {
                                                  'notes': notesController.text,
                                                  'date': DateTime.now(),
                                                }
                                              ]),
                                            });
                                            notesController.clear();
                                            showToast('Notes added!');
                                          }),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const Icon(Icons.add),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextBold(
                                                  text: 'Add Notes',
                                                  fontSize: 18,
                                                  color: Colors.black),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        userData1 = data;
                                      });
                                      printing();
                                    }),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.print),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextBold(
                                            text: 'Print',
                                            fontSize: 18,
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 130,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(data['image']),
                                            fit: BoxFit.cover)),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextBold(
                                          text: data['name'],
                                          fontSize: 48,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 125,
                                            child: Row(
                                              children: [
                                                TextRegular(
                                                    text: 'Age: ${data['age']}'
                                                        .toUpperCase(),
                                                    fontSize: 24,
                                                    color: Colors.black),
                                                IconButton(
                                                  onPressed: (() {
                                                    showDialog(
                                                        context: context,
                                                        builder: ((context) {
                                                          return AlertDialog(
                                                            content: SizedBox(
                                                              height: 100,
                                                              width: 200,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                child:
                                                                    TextFormField(
                                                                  controller:
                                                                      ageController,
                                                                  decoration: const InputDecoration(
                                                                      labelText:
                                                                          'New Age:'),
                                                                ),
                                                              ),
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    (() async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Patient')
                                                                      .doc(box.read(
                                                                          'id'))
                                                                      .update({
                                                                    'age':
                                                                        ageController
                                                                            .text
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                }),
                                                                child: TextBold(
                                                                    text:
                                                                        'Update',
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ],
                                                          );
                                                        }));
                                                  }),
                                                  icon: const Icon(
                                                      Icons.edit_square),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 200,
                                          ),
                                          TextRegular(
                                              text:
                                                  'Date of Birth: ${data['dateOfBirth']}'
                                                      .toUpperCase(),
                                              fontSize: 24,
                                              color: Colors.black),
                                        ],
                                      )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 800,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              TextRegular(
                                                  text: 'Sex: ${data['gender']}'
                                                      .toUpperCase(),
                                                  fontSize: 24,
                                                  color: Colors.black),
                                              const SizedBox(
                                                width: 200,
                                              ),
                                              SizedBox(
                                                width: 350,
                                                child: Row(
                                                  children: [
                                                    TextRegular(
                                                        text:
                                                            'Phone Number: ${data['phoneNumber']}'
                                                                .toUpperCase(),
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                    IconButton(
                                                      onPressed: (() {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                ((context) {
                                                              return AlertDialog(
                                                                content:
                                                                    SizedBox(
                                                                  height: 100,
                                                                  width: 200,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          contactNumController,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                              labelText: 'New Contact Number:'),
                                                                    ),
                                                                  ),
                                                                ),
                                                                actions: [
                                                                  TextButton(
                                                                    onPressed:
                                                                        (() async {
                                                                      await FirebaseFirestore
                                                                          .instance
                                                                          .collection(
                                                                              'Patient')
                                                                          .doc(box.read(
                                                                              'id'))
                                                                          .update({
                                                                        'phoneNumber':
                                                                            contactNumController.text
                                                                      });

                                                                      Navigator.pop(
                                                                          context);
                                                                    }),
                                                                    child: TextBold(
                                                                        text:
                                                                            'Update',
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                                ],
                                                              );
                                                            }));
                                                      }),
                                                      icon: const Icon(
                                                          Icons.edit_square),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                      Row(
                                        children: [
                                          TextRegular(
                                              text:
                                                  'Address: ${data['address']}'
                                                      .toUpperCase(),
                                              fontSize: 24,
                                              color: Colors.black),
                                          IconButton(
                                            onPressed: (() {
                                              showDialog(
                                                  context: context,
                                                  builder: ((context) {
                                                    return AlertDialog(
                                                      content: SizedBox(
                                                        height: 100,
                                                        width: 200,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: TextFormField(
                                                            controller:
                                                                brgyController,
                                                            decoration:
                                                                const InputDecoration(
                                                                    labelText:
                                                                        'New Patient Address:'),
                                                          ),
                                                        ),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: (() async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'Patient')
                                                                .doc(box
                                                                    .read('id'))
                                                                .update({
                                                              'address':
                                                                  brgyController
                                                                      .text
                                                            });

                                                            Navigator.pop(
                                                                context);
                                                          }),
                                                          child: TextBold(
                                                              text: 'Update',
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ],
                                                    );
                                                  }));
                                            }),
                                            icon: const Icon(Icons.edit_square),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 10, 30, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 450,
                            width: 900,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: TextBold(
                                        text: 'Medical Findings',
                                        fontSize: 38,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    width: 650,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            TextRegular(
                                                text:
                                                    'Disease: ${data['disease']}'
                                                        .toUpperCase(),
                                                fontSize: 24,
                                                color: Colors.black),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Row(
                                              children: [
                                                IconButton(
                                                  onPressed: (() async {
                                                    int nums = 0;

                                                    var collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Places')
                                                            .where('place',
                                                                isEqualTo: data[
                                                                    'brgy']);

                                                    var querySnapshot =
                                                        await collection.get();
                                                    if (mounted) {
                                                      setState(() {
                                                        for (var queryDocumentSnapshot
                                                            in querySnapshot
                                                                .docs) {
                                                          Map<String, dynamic>
                                                              data =
                                                              queryDocumentSnapshot
                                                                  .data();
                                                          nums = data['nums'];
                                                        }
                                                      });
                                                    }

                                                    if (data['isActive'] ==
                                                        true) {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Places')
                                                          .doc(data['brgy'])
                                                          .update({
                                                        "nums": nums - 1
                                                      });
                                                      showToast(
                                                          'Status updated succesfully!');
                                                    } else {
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('Places')
                                                          .doc(data['brgy'])
                                                          .update({
                                                        "nums": nums + 1
                                                      });
                                                      showToast(
                                                          'Status updated succesfully!');
                                                    }

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('Patient')
                                                        .doc(box.read('id'))
                                                        .update({
                                                      'isActive':
                                                          !data['isActive']
                                                    });
                                                  }),
                                                  icon: data['isActive']
                                                      ? const Icon(
                                                          Icons.toggle_on,
                                                          color: Colors.black,
                                                          size: 40,
                                                        )
                                                      : const Icon(
                                                          Icons
                                                              .toggle_off_sharp,
                                                          color: Colors.black,
                                                          size: 40,
                                                        ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        TextRegular(
                                            text:
                                                'Date of Findings: ${data['dateOfFindings']}'
                                                    .toUpperCase(),
                                            fontSize: 18,
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                    child: SizedBox(
                                      height: 75,
                                      width: 600,
                                      child: ListView(
                                        children: [
                                          for (int i = 0;
                                              i <
                                                  data['medicalFindings']
                                                      .length;
                                              i++)
                                            SizedBox(
                                              width: 600,
                                              child: ListTile(
                                                leading: const Icon(
                                                  Icons.note,
                                                ),
                                                title: TextRegular(
                                                    text:
                                                        'Notes: ${data['medicalFindings'][i]['notes']}',
                                                    fontSize: 24,
                                                    color: Colors.black),
                                                trailing: TextRegular(
                                                    text: DateFormat.yMMMd()
                                                        .add_jm()
                                                        .format(
                                                            data['medicalFindings']
                                                                    [i]['date']
                                                                .toDate()),
                                                    fontSize: 18,
                                                    color: Colors.black),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextFieldWidget(
                                      width: 800,
                                      height: 150,
                                      maxLine: 5,
                                      label: '',
                                      hint: 'Add Notes',
                                      controller: notesController),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextRegular(
                                          text: 'Assisted by:'.toUpperCase(),
                                          fontSize: 18,
                                          color: Colors.black),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextRegular(
                                              deco: TextDecoration.underline,
                                              text: '${data['assistedBy']}',
                                              fontSize: 24,
                                              color: Colors.black),
                                          TextRegular(
                                              text:
                                                  'SIGNATURE OVER PRINTED NAME',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
