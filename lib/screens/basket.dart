import 'package:app_frontend/io/http.dart';
import 'package:app_frontend/models.dart';
import 'package:app_frontend/widgets/buttons.dart';
import 'package:flutter/material.dart';

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Current Occupation Likelyhood: ${basket.occupation}%'),
            CustomButton(
              text: "Forecast Occupation",
              onPressed: () async {
                var date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
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
                    content: Text(
                      "Forecasted occupation likelyhood at specified time: $forecast%",
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
    );
  }
}
