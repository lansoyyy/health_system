import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';
import 'package:sumilao/widgets/brgy_dialog_widget.dart';
import 'package:sumilao/widgets/text_widget.dart';

class MapTab extends StatefulWidget {
  const MapTab({Key? key}) : super(key: key);

  @override
  State<MapTab> createState() => MapTabState();
}

class MapTabState extends State<MapTab> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  var brgys = [
    'Kisolon',
    'Kulasi',
    'Lican',
    'Lupiagan',
    'Ocasion',
    'Poblacion',
    'Puntian',
    'San Roque',
    'San Vicente',
    'Vista Villa',
  ];

  var datas = [];
  var datasMonth = [];
  var lats = [];
  var longs = [];
  var places = [];

  var hasLoaded = false;

  getData() async {
    for (int i = 0; i < brgys.length; i++) {
      var collection = FirebaseFirestore.instance
          .collection('Places')
          .where('place', isEqualTo: brgys[i]);

      var querySnapshot = await collection.get();

      setState(() {
        for (var queryDocumentSnapshot in querySnapshot.docs) {
          Map<String, dynamic> data = queryDocumentSnapshot.data();
          lats.add(data['lat']);
          longs.add(data['long']);
          datas.add(data['nums']);
          places.add(data['place']);
        }
      });
    }
    setState(() {});
  }

  List<Color> pinColors = [
    Colors.blue,
    Colors.black,
    Colors.amber,
    Colors.purple,
    Colors.brown,
    Colors.cyan,
    Colors.pink,
    Colors.grey,
    Colors.indigo,
    Colors.lime
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: InteractiveViewer(
                maxScale: 50,
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(8.348975, 124.972012),
                    zoom: 12.0,
                  ),
                  children: [
                    TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: const ['a', 'b', 'c']),
                    MarkerLayer(
                      markers: [
                        for (int i = 0; i < datas.length; i++)
                          Marker(
                            height: 120,
                            width: 120,
                            point: LatLng(lats[i], longs[i]),
                            builder: (ctx) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage(datas[i] >= 0 && datas[i] < 5
                                          ? 'assets/images/green.png'
                                          : datas[i] >= 5 && datas[i] < 11
                                              ? 'assets/images/orange.png'
                                              : 'assets/images/red.png'),
                                  opacity: 75,
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BarangayDialog(
                                            barangayName: places[i],
                                            riskType: 'Moderate',
                                          );
                                        });
                                  },
                                  icon: Icon(Icons.location_on_rounded,
                                      size: 32, color: pinColors[i]),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextBold(
                          text: 'LEGEND', fontSize: 18, color: Colors.black),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        child: ListView.builder(
                            itemCount: brgys.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                leading: TextBold(
                                    text: brgys[i],
                                    fontSize: 14,
                                    color: Colors.black),
                                trailing: Icon(Icons.location_on_rounded,
                                    size: 24, color: pinColors[i]),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
