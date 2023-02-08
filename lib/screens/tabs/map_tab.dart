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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(8.348975, 124.972012),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c']),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    point: LatLng(8.348975, 124.972012),
                    builder: (ctx) => Container(
                      child: Image.asset(
                        'assets/images/heat.png',
                        height: 25,
                        width: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            children: const [],
          )),
    );
  }
}
