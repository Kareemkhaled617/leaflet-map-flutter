import 'package:flutter/material.dart';
import 'package:leafleet_map/provider/provider.dart';
import 'package:leafleet_map/splash.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ProviderState>(
      create: (BuildContext context)=>ProviderState()..getData('0')..getMarkers('0')..checkLocation()..checkEnternet()..getSliderData('0')..getCurrentLocation(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashView(),
      ),
    );
  }
}


