import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:latlong2/latlong.dart';

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
    'San Roque',
    'San Vicente',
    'Vista Villa',
    'Puntian',
  ];

  var datas = [];
  var datasMonth = [];
  var lats = [];
  var longs = [];

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
        }
      });
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(datas);
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: InteractiveViewer(
            maxScale: 50,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(8.348975, 124.972012),
                zoom: 12.0,
              ),
              layers: [
                TileLayerOptions(
                    urlTemplate:
                        "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c']),
                MarkerLayerOptions(
                  markers: [
                    for (int i = 0; i < datas.length; i++)
                      Marker(
                        height: 120,
                        width: 120,
                        point: LatLng(lats[i], longs[i]),
                        builder: (ctx) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(datas[i] >= 0 && datas[i] < 5
                                  ? 'assets/images/green.png'
                                  : datas[i] >= 6 && datas[i] < 11
                                      ? 'assets/images/orange.png'
                                      : 'assets/images/red.png'),
                              opacity: 75,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              children: const [],
            ),
          )),
    );
  }
}
