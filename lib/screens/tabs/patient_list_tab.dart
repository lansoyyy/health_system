import 'package:flutter/material.dart';

import '../../widgets/button_widget.dart';
import '../../widgets/text_widget.dart';

class PatientListTab extends StatefulWidget {
  @override
  State<PatientListTab> createState() => _PatientListTabState();
}

class _PatientListTabState extends State<PatientListTab> {
  var filters = ['Name', 'Address', 'Gender'];

  final searchController = TextEditingController();

  var _dropValue = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextBold(
                  text: 'Search Patient', fontSize: 18, color: Colors.black),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(80, 0, 80, 20),
                child: Container(
                  width: 1000,
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
                                          value: i,
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.layers_rounded,
                                                color: Colors.black,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              TextRegular(
                                                  text:
                                                      'Filter by: ${filters[i]}',
                                                  fontSize: 14,
                                                  color: Colors.grey),
                                            ],
                                          ),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              DataTable(columns: [
                DataColumn(
                    label: TextBold(
                        text: 'Patient Name',
                        fontSize: 18,
                        color: Colors.black)),
                DataColumn(
                    label: TextBold(
                        text: 'Address', fontSize: 18, color: Colors.black)),
                DataColumn(
                    label: TextBold(
                        text: 'Gender', fontSize: 18, color: Colors.black)),
                DataColumn(
                    label: TextBold(
                        text: 'Disease', fontSize: 18, color: Colors.black)),
                DataColumn(
                    label:
                        TextBold(text: '', fontSize: 20, color: Colors.black)),
                DataColumn(
                    label:
                        TextBold(text: '', fontSize: 20, color: Colors.black)),
              ], rows: [
                for (int i = 0; i < 100; i++)
                  DataRow(cells: [
                    DataCell(TextRegular(
                        text: 'John Doe', fontSize: 14, color: Colors.grey)),
                    DataCell(TextRegular(
                        text: 'Kisolon Sumilao Bukidnon',
                        fontSize: 14,
                        color: Colors.grey)),
                    DataCell(TextRegular(
                        text: 'Male', fontSize: 14, color: Colors.grey)),
                    DataCell(TextRegular(
                        text: 'Dengue', fontSize: 14, color: Colors.grey)),
                    DataCell(ButtonWidget(
                        width: 75,
                        height: 40,
                        fontSize: 14,
                        label: 'Check',
                        onPressed: (() {}))),
                    DataCell(
                      Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 50,
                            width: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                border: Border.all(color: Colors.grey)),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.print,
                                    color: Colors.black,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  TextRegular(
                                      text: 'Print Report',
                                      fontSize: 12,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
              ])
            ],
          ),
        ),
      ),
    );
  }
}
