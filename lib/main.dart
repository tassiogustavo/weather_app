import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/pages/weather_page.dart';
import 'package:weather_app/providers/theme_changer.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeChanger>(
      create: (context) => ThemeChanger(ThemeData.dark()),
      child: Consumer<ThemeChanger>(
        builder: (context, ThemeChanger themeChanger, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: themeChanger.getTheme() == ThemeData.dark()
                ? ThemeData(
                    brightness: Brightness.dark,
                  )
                : ThemeData(
                    brightness: Brightness.light,
                  ),
            home: const WeatherPage(),
          );
        },
      ),
    );
  }
}
