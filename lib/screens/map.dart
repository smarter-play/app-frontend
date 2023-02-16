import 'dart:async';

import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/screens/basket.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  List<Marker> markers = [];
  MapController mapController = MapController();
  Timer? updateTimer;

  Future<void> initMarkers() async {
    await updateMapCenter();
    await updateMarkers();
  }

  Future<void> updateMarkers() async {
    var location = mapController.center;
    var bounds = mapController.bounds!;
    var radius = 110.574 * (bounds.north - bounds.south) * 1000;
    if (updateTimer != null && updateTimer!.isActive) {
      updateTimer!.cancel();
    }
    print("update markers, set timer");
    updateTimer = Timer(const Duration(milliseconds: 1000), () async {
      print("inside timer");
      var baskets = await backend.getBasketsInRange(
          location.latitude, location.longitude, radius);
      print(baskets);
      if (!mounted) return;
      setState(() {
        markers = baskets
            .map((e) => Marker(
                point: LatLng(e.lat, e.lon),
                builder: (_) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BasketScreen(basket: e),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      backgroundImage: AssetImage(
                        "assets/logo.jpg",
                      ),
                      radius: 20.0,
                    ),
                  );
                }))
            .toList();
      });
    });
  }

  StreamSubscription? sub;
  @override
  void initState() {
    super.initState();
    initMarkers();
    sub = mapController.mapEventStream.listen((_) => updateMarkers());
  }

  Future<void> updateMapCenter() async {
    var perm = await Geolocator.checkPermission();
    while (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever && mounted) {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Location permission denied"),
                content: const Text(
                    "Please enable location permission in your settings"),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"))
                ],
              ));
    }
    var location = await Geolocator.getCurrentPosition();
    if (mounted) {
      mapController.move(LatLng(location.latitude, location.longitude), 13);
    }
  }

  @override
  void dispose() {
    sub?.cancel();
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          center: LatLng(44.629, 10.949),
          zoom: 14.0,
          interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            tileProvider: NetworkTileProvider(),
            userAgentPackageName: 'com.smarterplay.smarterplay',
          ),
          MarkerLayer(
            markers: markers,
          )
        ],
      ),
    );
  }
}
