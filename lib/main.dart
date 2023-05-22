// ignore_for_file: unnecessary_new
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:light/light.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int threshold = 10;
  int _brightness = 0;
  late Light _light;
  late StreamSubscription _subscription;

  void onData(int luxValue) async {
    print("Lux value: $luxValue");
    setState(() {
      _brightness = luxValue;
    });
  }

  void stopListening() {
    _subscription.cancel();
  }

  void startListening() {
    _light = new Light();
    try {
      _subscription = _light.lightSensorStream.listen(onData);
    } on LightException catch (exception) {
      print(exception);
    }
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false, //remove debug banner
        //dark theme
        darkTheme: ThemeData(
            useMaterial3: true, // new material design
            scaffoldBackgroundColor: const Color.fromARGB(255, 44, 40, 40),
            appBarTheme: const AppBarTheme(
                color: Colors.blueAccent,
                elevation: 10, //shadow
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))),
        //light theme
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 246, 240, 240),
            appBarTheme: const AppBarTheme(
                color: Color.fromARGB(255, 47, 134, 193),
                elevation: 10,
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))),
        themeMode: _brightness < threshold ? ThemeMode.dark : ThemeMode.light,
        home: new Scaffold(
          appBar: new AppBar(
            title: const Text(
              'Light/Dark',
            ),
          ),
          body: Center(
            child: Column(
              children: [
                const Spacer(
                  flex: 1,
                ),
                _brightness < threshold
                    ? const Hero(
                        //animation between light and dark
                        tag: "light_dark", //must be the same tag to work
                        child: Icon(Icons.dark_mode,
                            size: 150, color: Colors.white))
                    : const Hero(
                        //animation between light and dark
                        tag: "light_dark",
                        child: Icon(Icons.light_mode,
                            size: 150, color: Colors.black)),
                Text('Karim Ahmed ',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color:
                          _brightness < threshold ? Colors.white : Colors.black,
                    )),
                const Spacer(
                  flex: 2,
                ),
                Text(
                  'brightness level: $_brightness\n',
                  style: TextStyle(
                    color:
                        _brightness < threshold ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
