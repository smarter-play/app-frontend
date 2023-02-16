import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class BasketScreen extends StatelessWidget {
  const BasketScreen({Key? key, required this.basket}) : super(key: key);
  final Basket basket;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Basket ${basket.id}'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: FlutterMap(
                  options: MapOptions(
                    center: LatLng(basket.lat, basket.lon),
                    zoom: 14.0,
                    interactiveFlags: InteractiveFlag.pinchZoom +
                        InteractiveFlag.doubleTapZoom,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      tileProvider: NetworkTileProvider(),
                      userAgentPackageName: 'com.smarterplay.smarterplay',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(basket.lat, basket.lon),
                          builder: (_) => const CircleAvatar(
                            backgroundImage: AssetImage(
                              "assets/logo.jpg",
                            ),
                            radius: 20.0,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Text(
                'Current Occupation Likelyhood:',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              Text(
                "${basket.occupation}%",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                height: 16.0,
              ),
              CustomButton(
                text: "Forecast Occupation",
                onPressed: () async {
                  var date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date == null || !context.mounted) return;
                  var time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time == null || !context.mounted) return;
                  var dateTime = DateTime(
                    date.year,
                    date.month,
                    date.day,
                    time.hour,
                    time.minute,
                  );

                  var forecast = await backend.forecastOccupation(
                    basket.id,
                    dateTime,
                  );
                  if (!context.mounted) return;
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Occupation Likelyhood Forecast"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Forecasted occupation likelyhood at specified time:",
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "$forecast%",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
