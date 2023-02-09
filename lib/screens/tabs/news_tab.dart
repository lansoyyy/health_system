import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:sumilao/services/add_news.dart';
import 'package:sumilao/services/local_storage.dart';
import 'package:sumilao/utils/colors.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';
import '../../widgets/textfield_widget.dart';
import '../../widgets/toast_widget.dart';

class NewsTab extends StatefulWidget {
  @override
  State<NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<NewsTab> {
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

  final headlineController = TextEditingController();
  final titleController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: box.read('user') == 'Admin'
          ? FloatingActionButton(
              backgroundColor: primary,
              onPressed: (() {
                showDialog(
                    context: context,
                    builder: ((context) {
                      return StatefulBuilder(builder: ((context, setState) {
                        return Dialog(
                          child: SizedBox(
                            height: 650,
                            width: 400,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Column(
                                children: [
                                  hasLoaded
                                      ? Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              image: DecorationImage(
                                                  image: NetworkImage(imgUrl),
                                                  fit: BoxFit.cover)),
                                          height: 150,
                                          width: 300,
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
                                          width: 300,
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
                                    height: 10,
                                  ),
                                  TextFieldWidget(
                                      label: 'Headline',
                                      controller: headlineController),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldWidget(
                                      label: 'Title',
                                      controller: titleController),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextFieldWidget(
                                      height: 100,
                                      maxLine: 5,
                                      label: 'Details',
                                      controller: detailsController),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  ButtonWidget(
                                      label: 'Continue',
                                      onPressed: (() {
                                        Navigator.pop(context);
                                        addNews(
                                            imgUrl,
                                            headlineController.text,
                                            titleController.text,
                                            detailsController.text);
                                        showToast('Added Succesfully!');
                                      }))
                                ],
                              ),
                            ),
                          ),
                        );
                      }));
                    }));
              }),
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ))
          : const SizedBox(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBold(
                  text: 'NEWS AND UPDATES', fontSize: 24, color: Colors.black),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                  stream:
                      FirebaseFirestore.instance.collection('News').snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      print('error');
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
                    return SizedBox(
                      height: 800,
                      child: ListView.separated(
                          itemCount: data.docs.length,
                          separatorBuilder: ((context, index) {
                            return const Divider();
                          }),
                          itemBuilder: ((context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Card(
                                        child: Container(
                                          height: 300,
                                          width: 500,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.grey),
                                          child: Center(
                                              child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                image: DecorationImage(
                                                    image: NetworkImage(data
                                                        .docs[index]['image']),
                                                    fit: BoxFit.cover)),
                                          )),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextBold(
                                          text: data.docs[index]['headline'],
                                          fontSize: 18,
                                          color: Colors.black),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextBold(
                                          text: data.docs[index]['title'],
                                          fontSize: 22,
                                          color: Colors.black),
                                      SizedBox(
                                        width: 500,
                                        child: TextRegular(
                                            text: data.docs[index]
                                                ['description'],
                                            fontSize: 18,
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          })),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
