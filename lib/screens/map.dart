import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

class MapWidget extends StatefulWidget {
  final List<Marker> markers;

  const MapWidget({Key? key, required this.markers}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(),
      ),
    );
  }
}
