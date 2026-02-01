import 'package:flutter/material.dart';

class AdditionalInfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String value;
  const AdditionalInfoCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 124,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                icon,
                size: 36,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
