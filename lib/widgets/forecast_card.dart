import 'package:flutter/material.dart';

class ForecastCard extends StatelessWidget {
  final String time;
  final String icon;
  final String description;
  const ForecastCard(
      {super.key,
      required this.time,
      required this.icon,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.network(
              "https://openweathermap.org/img/w/$icon.png",
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
