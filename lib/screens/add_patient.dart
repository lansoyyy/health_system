import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/add_patient.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

import '../widgets/appbar_widget.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({super.key});

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
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

  var lats = [
    8.331635,
    8.276836,
    8.214124,
    8.201508,
    8.245051,
    8.287519,
    8.332622,
    8.356091,
    8.338830,
    8.291026,
  ];

  double lat = 8.331635;
  double long = 124.976005;

  var longs = [
    124.976005,
    124.924843,
    124.905968,
    124.929829,
    124.901814,
    124.948132,
    124.935717,
    124.975748,
    124.975427,
    124.905548
  ];

  var diseases = ['No Sickness', 'Covid', 'Dengue', 'Diarrhea'];

  final nameController = TextEditingController();

  final phoneNumberController = TextEditingController();

  final dateOfBirthController = TextEditingController();

  final ageController = TextEditingController();

  final addressController = TextEditingController();

  final findingsController = TextEditingController();

  final dateFindingsController = TextEditingController();

  final assistedController = TextEditingController();

  late String dateOfBirth = '';

  late String dateFindings = '';

  var _dropValue = 0;
  var _dropValue1 = 0;

  var _dropValue2 = 0;
  var _dropValue3 = 0;

  String brgy = 'Kisolon';
  String zone = 'Zone 1';
  String gender = 'Male';
  String disease = 'No Sickness';

  late String imgUrl = '';

  var hasLoaded = false;

  String filterData = '';
  String filterMonth = '';

  uploadToStorage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    FirebaseStorage fs = FirebaseStorage.instance;
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        var snapshot = await fs.ref().child('newfile').putBlob(file);
        String downloadUrl = await snapshot.ref.getDownloadURL();

        showToast('Image Uploaded!');

        print(downloadUrl);
        setState(() {
          imgUrl = downloadUrl;
          hasLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
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
                          text: 'ADDING PATIENT',
                          fontSize: 58,
                          color: Colors.black),
                      const SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                  customAppbar('Patient Management'),
                  const SizedBox(
                    height: 20,
                  ),
                  hasLoaded
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              image: DecorationImage(
                                  image: NetworkImage(imgUrl),
                                  fit: BoxFit.cover)),
                          height: 150,
                          width: 200,
                          child: Center(
                            child: TextRegular(
                                text: 'Image Uploaded',
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 700),
                          child: Container(
                            color: Colors.grey,
                            height: 150,
                            width: 200,
                            child: Center(
                              child: TextRegular(
                                  text: 'No Photo',
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 700),
                    child: ButtonWidget(
                        width: 100,
                        height: 35,
                        fontSize: 12,
                        label: 'Upload Photo',
                        onPressed: (() {
                          uploadToStorage();
                        })),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 1000,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                width: 300,
                                label: 'Full Name',
                                controller: nameController),
                            const SizedBox(
                              width: 20,
                            ),
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    setState(() {
                                      dateOfBirth =
                                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                                    });
                                  }
                                },
                                readOnly: true,
                                inputType: TextInputType.datetime,
                                width: 150,
                                label: 'Date of Birth',
                                hint: dateOfBirth,
                                controller: dateOfBirthController),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                width: 240,
                                inputType: TextInputType.number,
                                label: 'Phone Number',
                                controller: phoneNumberController),
                            const SizedBox(
                              width: 150,
                            ),
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                inputType: TextInputType.number,
                                width: 150,
                                label: 'Age',
                                controller: ageController),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextRegular(
                                    text: 'Barangay:'.toUpperCase(),
                                    fontSize: 24,
                                    color: Colors.black),
                                const SizedBox(
                                  width: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Center(
                                      child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          value: _dropValue,
                                          items: [
                                            for (int i = 0;
                                                i < brgys.length;
                                                i++)
                                              DropdownMenuItem(
                                                onTap: () {
                                                  brgy = brgys[i];
                                                  lat = lats[i];
                                                  long = longs[i];
                                                },
                                                value: i,
                                                child: TextRegular(
                                                    text: brgys[i],
                                                    fontSize: 18,
                                                    color: Colors.black),
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 135,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextRegular(
                                    text: 'Zone:'.toUpperCase(),
                                    fontSize: 24,
                                    color: Colors.black),
                                const SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 150,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      border: Border.all(color: Colors.black)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                    child: Center(
                                      child: DropdownButton(
                                          dropdownColor: Colors.white,
                                          focusColor: Colors.white,
                                          value: _dropValue1,
                                          items: [
                                            for (int i = 0; i < 4; i++)
                                              DropdownMenuItem(
                                                onTap: () {
                                                  zone = 'Zone ${i + 1}';
                                                },
                                                value: i,
                                                child: TextRegular(
                                                    text: 'Zone ${i + 1}',
                                                    fontSize: 18,
                                                    color: Colors.black),
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 45,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        box.read('user') != 'Nurse'
                            ? Row(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextRegular(
                                          text: 'Disease:'.toUpperCase(),
                                          fontSize: 24,
                                          color: Colors.black),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 330,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: Center(
                                            child: DropdownButton(
                                                dropdownColor: Colors.white,
                                                focusColor: Colors.white,
                                                value: _dropValue3,
                                                items: [
                                                  for (int i = 0;
                                                      i < diseases.length;
                                                      i++)
                                                    DropdownMenuItem(
                                                      onTap: (() {
                                                        disease = diseases[i];
                                                      }),
                                                      value: i,
                                                      child: TextRegular(
                                                          text: diseases[i],
                                                          fontSize: 14,
                                                          color: Colors.black),
                                                    ),
                                                ],
                                                onChanged: ((value) {
                                                  setState(() {
                                                    _dropValue3 = int.parse(
                                                        value.toString());
                                                  });
                                                })),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 160,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextRegular(
                                          text: 'Sex:'.toUpperCase(),
                                          fontSize: 24,
                                          color: Colors.black),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black)),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 0, 20, 0),
                                          child: Center(
                                            child: DropdownButton(
                                                dropdownColor: Colors.white,
                                                focusColor: Colors.white,
                                                value: _dropValue2,
                                                items: [
                                                  DropdownMenuItem(
                                                    onTap: () {
                                                      gender = 'Male';
                                                    },
                                                    value: 0,
                                                    child: TextRegular(
                                                        text: 'Male',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                  DropdownMenuItem(
                                                    onTap: () {
                                                      gender = 'Female';
                                                    },
                                                    value: 1,
                                                    child: TextRegular(
                                                        text: 'Female',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                  DropdownMenuItem(
                                                    onTap: () {
                                                      gender = 'Others';
                                                    },
                                                    value: 2,
                                                    child: TextRegular(
                                                        text: 'Others',
                                                        fontSize: 18,
                                                        color: Colors.black),
                                                  ),
                                                ],
                                                onChanged: ((value) {
                                                  setState(() {
                                                    _dropValue2 = int.parse(
                                                        value.toString());
                                                  });
                                                })),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        box.read('user') != 'Nurse'
                            ? TextFieldWidget(
                                capital: true,
                                width: 800,
                                height: 150,
                                maxLine: 5,
                                label: 'Medical Findings:'.toUpperCase(),
                                controller: findingsController)
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                onPressed: () async {
                                  final DateTime? selectedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );

                                  if (selectedDate != null) {
                                    setState(() {
                                      dateFindings =
                                          "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
                                    });
                                  }
                                },
                                readOnly: true,
                                inputType: TextInputType.datetime,
                                width: 180,
                                label: 'Date of Findings',
                                hint: dateFindings,
                                controller: dateFindingsController),
                            const SizedBox(
                              width: 30,
                            ),
                            TextFieldWidget(
                                capital: true,
                                onSide: true,
                                width: 200,
                                label: 'Assisted by',
                                controller: assistedController),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                  ButtonWidget(
                    label: 'Add Patient',
                    onPressed: (() async {
                      // for (int i = 0; i < brgys.length; i++) {
                      //   await FirebaseFirestore.instance
                      //       .collection('Places')
                      //       .doc(brgys[i])
                      //       .update({
                      //     'lat': lats[i],
                      //     'long': longs[i],
                      //   });
                      // }
                      int nums = 0;

                      var collection = FirebaseFirestore.instance
                          .collection('Places')
                          .where('place', isEqualTo: brgy);

                      var querySnapshot = await collection.get();
                      if (mounted) {
                        setState(() {
                          for (var queryDocumentSnapshot
                              in querySnapshot.docs) {
                            Map<String, dynamic> data =
                                queryDocumentSnapshot.data();
                            nums = data['nums'];
                          }
                        });
                      }

                      await FirebaseFirestore.instance
                          .collection('Places')
                          .doc(brgy)
                          .update({"nums": nums + 1});
                      showToast('Patient added succesfully!');
                      if (box.read('user') == 'Nurse') {
                        addPatient(
                            imgUrl,
                            nameController.text,
                            phoneNumberController.text,
                            dateOfBirth,
                            ageController.text,
                            brgy,
                            zone,
                            gender,
                            disease,
                            addressController.text,
                            '',
                            dateFindings,
                            assistedController.text,
                            lat,
                            long);
                      } else {
                        addPatient(
                            imgUrl,
                            nameController.text,
                            phoneNumberController.text,
                            dateOfBirth,
                            ageController.text,
                            brgy,
                            zone,
                            gender,
                            disease,
                            '',
                            findingsController.text,
                            dateFindings,
                            assistedController.text,
                            lat,
                            long);
                      }
                      Navigator.pushReplacementNamed(context, '/homescreen');
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
