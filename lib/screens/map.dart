import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final List<Marker> markers;

  const MapWidget({Key? key, required this.markers}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController mapController = MapController();
  @override
  void initState() {
    super.initState();
  }

  Future<void> updateMapCenter() async {
    var permission = await Geolocator.checkPermission();
    while (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) {
      return;
    }
    var value = await Geolocator.getCurrentPosition();
    mapController.move(LatLng(value.latitude, value.longitude), 15);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 300,
      color: Colors.green,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(51.5, -0.09),
          zoom: 13.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: NetworkTileProvider(),
            userAgentPackageName: 'com.smarterplay.smarterplay',
          ),
        ],
      ),
    );
  }
}
