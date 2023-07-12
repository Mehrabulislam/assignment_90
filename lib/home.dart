
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import '../API/constant.dart';



class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String _location = '';
  String _temperature = '';
  String _weatherDescription = '';
  String _weatherIconUrl = '';
  String _tempMin = '';
  String _tempMax = '';
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }

    try {
      final Response response = await get(Uri.parse(apiBaseUrl));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final mainData = jsonData['main'];
        final weatherData = jsonData['weather'][0];

        _location = jsonData['name'];
        _temperature = mainData['temp'].toString();
        _weatherDescription = weatherData['description'];

        _tempMax = mainData['temp_max'].toString();
        _tempMin = mainData['temp_min'].toString();
        _weatherIconUrl =
        'http://openweathermap.org/img/w/${weatherData['icon']}.png';
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      } else {
        _errorMessage = 'Error fetching weather data';
        _isLoading = false;
        if (mounted) {
          setState(() {});
        }
      }
    } catch (error) {
      _errorMessage = 'Error fetching weather data';
      _isLoading = false;
      if (mounted) {
        setState(() {});
      }
    }}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF873bcc),
        title: const Text('Weather App'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _fetchWeatherData();
              if (mounted) {
                setState(() {});
              }
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff450185),
                Color(0xFF873bcc),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              else
                Column(
                  children: [
                    Text(
                      _location,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Updated: ${DateFormat.jm().format(DateTime.now())}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color.fromARGB(255, 153, 148, 148)),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.network(
                            _weatherIconUrl,
                            errorBuilder: (_, __, ___) {
                              return const Icon(
                                Icons.image,
                              );
                            },
                          ),
                          Text(
                            '$_temperature°C',
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Max: $_tempMax°C',
                                style: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 153, 148, 148),
                                ),
                              ),
                              Text(
                                'Min: $_tempMin°C',
                                style: const TextStyle(
                                    color: Color.fromARGB(
                                        255, 153, 148, 148),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      _weatherDescription,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
