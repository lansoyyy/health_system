import 'package:cloud_firestore/cloud_firestore.dart';

Future addPlaces(String place) async {
  final docUser = FirebaseFirestore.instance.collection('Places').doc(place);

  final json = {'place': place, 'nums': 0, 'lat': 0, 'long': 0};

  await docUser.set(json);
}
