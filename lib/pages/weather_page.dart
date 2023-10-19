import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/constants.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/pages/utils/searche_delegate_cities.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/providers/theme_changer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api key
  final _weatherService = WeatherService(key);
  Weather? _weather;

  //fetch weather
  _fethWeather() async {
    // get the current city
    String cityName = await _weatherService.getCurrentCity();

    // get weather for city
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } //any errors
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  _changeWeather(String cityName) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } //any errors
    catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  // weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  // init state
  @override
  void initState() {
    super.initState();
    _fethWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {
                    String city = await showSearch(
                      context: context,
                      delegate: SearchDelegateCities(),
                    );
                    _changeWeather(city);
                  },
                  icon: const Icon(Icons.search),
                ),
                IconButton(
                  onPressed: () {
                    _fethWeather();
                  },
                  icon: const Icon(Icons.location_pin),
                ),
                Provider.of<ThemeChanger>(context, listen: true).getTheme() ==
                        ThemeData.dark()
                    ? IconButton(
                        onPressed: () {
                          Provider.of<ThemeChanger>(context, listen: false)
                              .setTheme(ThemeData.light());
                        },
                        icon: const Icon(Icons.sunny),
                      )
                    : IconButton(
                        onPressed: () {
                          Provider.of<ThemeChanger>(context, listen: false)
                              .setTheme(ThemeData.dark());
                        },
                        icon: const Icon(Icons.nightlight),
                      ),
              ],
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Icon(
                      Icons.location_pin,
                      size: 25,
                    ),
                  ),
                  Text(
                    _weather?.cityName.toUpperCase() ?? "loading city...",
                    style: GoogleFonts.oswald(
                        fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 70),
                    child: Lottie.asset(
                        getWeatherAnimation(_weather?.mainCondition)),
                  ),
                  Text(
                    '${_weather?.temperature.round().toString()}°',
                    style: GoogleFonts.oswald(
                        fontSize: 40, fontWeight: FontWeight.w500),
                  ),
                  //Text(_weather?.mainCondition ?? ""),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
