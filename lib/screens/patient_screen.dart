import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'package:sumilao/widgets/appbar_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';
import 'package:pdf/widgets.dart' as pw;

class PatientScreen extends StatelessWidget {
  final ssController = ScreenshotController();
  final notesController = TextEditingController();

  final box = GetStorage();

  final doc = pw.Document();

  printing(Uint8List capturedImage) async {
    doc.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Container(
            height: double.infinity,
            width: double.infinity,
            child: pw.Image(
                pw.MemoryImage(
                  capturedImage,
                ),
                height: 1000,
                width: 1000));
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
              appBar: customAppbar('Patient Profile'),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Container(
                        width: double.infinity,
                        height: 210,
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
                                  GestureDetector(
                                    onTap: (() async {
                                      if (notesController.text == '') {
                                        showToast(
                                            'Update failed! No new Input');
                                      } else {
                                        showToast(
                                            'Findings updated succesfully!');
                                        await FirebaseFirestore.instance
                                            .collection('Patient')
                                            .doc(data['id'])
                                            .update({
                                          'medicalFindings':
                                              notesController.text
                                        });
                                      }
                                    }),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.edit),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        TextBold(
                                            text: 'Edit Notes',
                                            fontSize: 18,
                                            color: Colors.black),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  GestureDetector(
                                    onTap: (() {
                                      ssController
                                          .capture(
                                              delay: const Duration(
                                                  milliseconds: 10))
                                          .then((capturedImage) async {
                                        printing(capturedImage!);
                                      }).catchError((onError) {
                                        print(onError);
                                      });
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
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextBold(
                                          text: data['name'],
                                          fontSize: 32,
                                          color: Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 400,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: Row(
                                                  children: [
                                                    TextRegular(
                                                        text:
                                                            'Age: ${data['age']}',
                                                        fontSize: 14,
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
                                                                          ageController,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                              labelText: 'New Age:'),
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
                                                                        'age': ageController
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
                                                          Icons.edit),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              TextRegular(
                                                  text:
                                                      'Date of Birth: ${data['dateOfBirth']}',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                            ],
                                          )),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                          width: 400,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextRegular(
                                                  text:
                                                      'Gender: ${data['gender']}',
                                                  fontSize: 14,
                                                  color: Colors.black),
                                              SizedBox(
                                                width: 230,
                                                child: Row(
                                                  children: [
                                                    TextRegular(
                                                        text:
                                                            'Phone Number: ${data['phoneNumber']}',
                                                        fontSize: 14,
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
                                                          Icons.edit),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
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
                      padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 500,
                            height: 240,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Center(
                                      child: TextBold(
                                          text: 'Address',
                                          fontSize: 24,
                                          color: Colors.black)),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  SizedBox(
                                    width: 220,
                                    child: Row(
                                      children: [
                                        TextRegular(
                                            text: 'Baranggay: ${data['brgy']}',
                                            fontSize: 15,
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
                                                                      'Baranggay:'),
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
                                                            'brgy':
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
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 140,
                                    child: Row(
                                      children: [
                                        TextRegular(
                                            text: 'Zone: ${data['zone']}',
                                            fontSize: 15,
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
                                                              zoneController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'Zone:'),
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
                                                            'zone':
                                                                zoneController
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
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    width: 320,
                                    child: Row(
                                      children: [
                                        TextRegular(
                                            text:
                                                'Complete Address: ${data['address']}',
                                            fontSize: 15,
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
                                                              addressController,
                                                          decoration:
                                                              const InputDecoration(
                                                                  labelText:
                                                                      'New Address:'),
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
                                                                addressController
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
                                          icon: const Icon(Icons.edit),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Container(
                              height: 400,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Center(
                                      child: TextBold(
                                          text: 'Medical Findings',
                                          fontSize: 24,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    SizedBox(
                                      width: 500,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextRegular(
                                              text:
                                                  'Disease: ${data['disease']}',
                                              fontSize: 15,
                                              color: Colors.black),
                                          TextRegular(
                                              text:
                                                  'Date Findings: ${data['dateOfFindings']}',
                                              fontSize: 15,
                                              color: Colors.black),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFieldWidget(
                                        height: 150,
                                        width: 500,
                                        maxLine: 5,
                                        label: 'Notes:',
                                        hint: data['medicalFindings'],
                                        controller: notesController),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    TextRegular(
                                        text:
                                            'Assisted by: ${data['assistedBy']}',
                                        fontSize: 15,
                                        color: Colors.black),
                                  ],
                                ),
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
