import 'dart:html';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/add_patient.dart';
import 'package:sumilao/widgets/button_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';
import 'package:sumilao/widgets/textfield_widget.dart';
import 'package:sumilao/widgets/toast_widget.dart';

import '../widgets/appbar_widget.dart';

class AddPatient extends StatefulWidget {
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
      appBar: customAppbar('Patient Management'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextBold(
                  text: 'Adding Patient', fontSize: 24, color: Colors.black),
              const SizedBox(
                height: 20,
              ),
              hasLoaded
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          image: DecorationImage(
                              image: NetworkImage(imgUrl), fit: BoxFit.cover)),
                      height: 150,
                      width: 200,
                      child: Center(
                        child: TextRegular(
                            text: 'Image Uploaded',
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    )
                  : Container(
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
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                  width: 100,
                  height: 35,
                  fontSize: 12,
                  label: 'Upload Photo',
                  onPressed: (() {
                    uploadToStorage();
                  })),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                      label: 'Full Name', controller: nameController),
                  const SizedBox(
                    width: 30,
                  ),
                  TextFieldWidget(
                      inputType: TextInputType.number,
                      label: 'Phone Number',
                      controller: phoneNumberController),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                      inputType: TextInputType.datetime,
                      width: 180,
                      label: 'Date of Birth',
                      controller: dateOfBirthController),
                  const SizedBox(
                    width: 30,
                  ),
                  TextFieldWidget(
                      inputType: TextInputType.number,
                      width: 100,
                      label: 'Age',
                      controller: ageController),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextRegular(
                          text: 'Barangay', fontSize: 16, color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Center(
                            child: DropdownButton(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                value: _dropValue,
                                items: [
                                  for (int i = 0; i < brgys.length; i++)
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
                                    _dropValue = int.parse(value.toString());
                                  });
                                })),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextRegular(
                          text: 'Zone', fontSize: 16, color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                    _dropValue1 = int.parse(value.toString());
                                  });
                                })),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextRegular(
                          text: 'Gender', fontSize: 16, color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                ],
                                onChanged: ((value) {
                                  setState(() {
                                    _dropValue2 = int.parse(value.toString());
                                  });
                                })),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextRegular(
                          text: 'Disease', fontSize: 16, color: Colors.black),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            border: Border.all(color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Center(
                            child: DropdownButton(
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                value: _dropValue3,
                                items: [
                                  for (int i = 0; i < diseases.length; i++)
                                    DropdownMenuItem(
                                      onTap: (() {
                                        disease = diseases[i];
                                      }),
                                      value: i,
                                      child: TextRegular(
                                          text: diseases[i],
                                          fontSize: 18,
                                          color: Colors.black),
                                    ),
                                ],
                                onChanged: ((value) {
                                  setState(() {
                                    _dropValue3 = int.parse(value.toString());
                                  });
                                })),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  TextFieldWidget(
                      width: 300,
                      label: 'Address',
                      controller: addressController),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                  width: 500,
                  height: 100,
                  maxLine: 5,
                  label: 'Medical Findings',
                  controller: findingsController),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFieldWidget(
                      inputType: TextInputType.datetime,
                      label: 'Date of Findings',
                      controller: dateFindingsController),
                  const SizedBox(
                    width: 30,
                  ),
                  TextFieldWidget(
                      label: 'Assist by', controller: assistedController),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              ButtonWidget(
                label: 'Add Patient',
                onPressed: (() {
                  showToast('Patient added succesfully!');
                  addPatient(
                      imgUrl,
                      nameController.text,
                      phoneNumberController.text,
                      dateOfBirthController.text,
                      ageController.text,
                      brgy,
                      zone,
                      gender,
                      disease,
                      addressController.text,
                      findingsController.text,
                      dateFindingsController.text,
                      assistedController.text,
                      lat,
                      long);
                  Navigator.pushReplacementNamed(context, '/homescreen');
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
