import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/widgets/additional_info.dart';
import 'package:weatherapp/widgets/forecast_card.dart';


void main() {
  runApp(
    WeatherApp(),
  );
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return WeatherAppState();
  }
}

class WeatherAppState extends State {
  Future<Map<String, dynamic>> getweatherdata() async {
    try {
      final responce = await http.get(
        Uri.parse(
          "https://api.openweathermap.org/data/2.5/forecast?q=london,uk&APPID=2d71019188816c9b102e5574697b536c",
        ),
      );

      final data = jsonDecode(responce.body);

      return data;
    } catch (e) {
      throw Exception("Some Error Occured While fetching Weather Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Weather App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Weather App",
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: Icon(
                Icons.refresh,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: getweatherdata(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(),
              );
            } else if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              final data = snapshot.data;
              final currentTemp = data!["list"][0]["main"]["temp"];
              final description = data!["list"][0]["weather"][0]["description"];
              final humidity = data!["list"][0]["main"]["humidity"];
              final wind = data!["list"][0]["wind"]["speed"];
              final pressure = data!["list"][0]["main"]["pressure"];
              final icon = data!["list"][0]["weather"][0]["icon"];

              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================== Main Box Starts =================
                    SizedBox(
                      width: double.infinity,
                      height: 200,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(
                              sigmaX: 10,
                              sigmaY: 10,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${(currentTemp - 273.15).toStringAsFixed(1)}°C",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Image.network(
                                  "https://openweathermap.org/img/w/$icon.png",
                                ),
                                Text(
                                  description,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // ================== Main Box Ends =================
                    // ================== Hourly Forecast Section Start =================
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Text(
                        "Hourly Forecast",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          final forecastData = data["list"][index + 1];

                          final String icon =
                              forecastData["weather"][0]["icon"];
                          final String description =
                              forecastData["weather"][0]["description"];
                          final DateTime time =
                              DateTime.parse(forecastData["dt_txt"]);

                          return ForecastCard(
                            icon: icon,
                            time: DateFormat.jm().format(time),
                            description: description,
                          );
                        },
                      ),
                    ),
                    // ================== Hourly Forecast Section End =================

                    // ================== Additional Information Section Start =================
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6,
                      ),
                      child: Text(
                        "Additional Information",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AdditionalInfoCard(
                          title: "Humidity",
                          icon: Icons.water_drop,
                          value: "$humidity %",
                        ),
                        AdditionalInfoCard(
                          title: "Wind",
                          icon: Icons.air,
                          value: "$wind km/h",
                        ),
                        AdditionalInfoCard(
                          title: "Pressure",
                          icon: Icons.thermostat,
                          value: "$pressure mb",
                        ),
                      ],
                    )

                    // ================== Additional Information Section End =================
                  ],
                ),
              );
            } else {
              return Center(
                child: Text("Some Error Occured"),
              );
            }
          },
        ),
      ),
    );
  }
}
