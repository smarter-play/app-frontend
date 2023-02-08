import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapWidget extends StatefulWidget {
  final List<Marker> markers;

  const MapWidget({Key? key, required this.markers}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 10,
        ),
        markers: Set.from(widget.markers),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
