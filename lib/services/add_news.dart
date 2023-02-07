import 'package:cloud_firestore/cloud_firestore.dart';

Future addNews(String image, headline, title, description) async {
  final docUser = FirebaseFirestore.instance.collection('News').doc();

  final json = {
    'image': image,
    'headline': headline,
    'title': title,
    'description': description,
  };

  await docUser.set(json);
}
