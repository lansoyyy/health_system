import 'package:cloud_firestore/cloud_firestore.dart';

Future addPatient(
    image,
    name,
    phoneNumber,
    dateOfBirth,
    age,
    brgy,
    zone,
    gender,
    disease,
    address,
    medicalFindings,
    dateOfFindings,
    assistedBy,
    lat,
    long) async {
  final docUser = FirebaseFirestore.instance.collection('Patient').doc();

  final json = {
    'image': image,
    'name': name,
    'phoneNumber': phoneNumber,
    'dateOfBirth': dateOfBirth,
    'age': age,
    'brgy': brgy,
    'zone': zone,
    'gender': gender,
    'disease': disease,
    'address': address,
    'medicalFindings': medicalFindings,
    'dateOfFindings': dateOfFindings,
    'assistedBy': assistedBy,
    'lat': lat,
    'long': long
  };

  await docUser.set(json);
}
