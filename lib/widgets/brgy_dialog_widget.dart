import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/widgets/text_widget.dart';

class BarangayDialog extends StatelessWidget {
  final String barangayName;
  final String riskType;

  const BarangayDialog({
    super.key,
    required this.barangayName,
    required this.riskType,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(width: 500, child: contentBox(context)),
    );
  }

  Widget contentBox(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              return Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 20, right: 20, bottom: 20),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10.0,
                      offset: Offset(0.0, 10.0),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Municipality of Sumilao',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextRegular(
                      text: 'Barangay: $barangayName',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 8),
                    TextRegular(
                      text: 'Risk Type: $riskType',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    const SizedBox(height: 15),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Places')
                            .where('brgy', isEqualTo: barangayName)
                            .where('disease', isEqualTo: 'Covid')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return TextRegular(
                            text: 'COVID-19 Cases: ${data.docs.length}',
                            fontSize: 16,
                            color: Colors.black,
                          );
                        }),
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Places')
                            .where('brgy', isEqualTo: barangayName)
                            .where('disease', isEqualTo: 'Diarrhea')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return TextRegular(
                            text: 'Diarrhea Cases: ${data.docs.length}',
                            fontSize: 16,
                            color: Colors.black,
                          );
                        }),
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Places')
                            .where('brgy', isEqualTo: barangayName)
                            .where('disease', isEqualTo: 'Dengue')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return TextRegular(
                            text: 'Dengue Cases: ${data.docs.length}',
                            fontSize: 16,
                            color: Colors.black,
                          );
                        }),
                    const SizedBox(height: 8),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('Places')
                            .where('brgy', isEqualTo: barangayName)
                            .where('disease', isEqualTo: 'No Sickness')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            print('error');
                            return const Center(child: Text('Error'));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                  child: CircularProgressIndicator(
                                color: Colors.black,
                              )),
                            );
                          }

                          final data = snapshot.requireData;
                          return TextRegular(
                            text: 'No Sickness: ${data.docs.length}',
                            fontSize: 16,
                            color: Colors.black,
                          );
                        }),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
