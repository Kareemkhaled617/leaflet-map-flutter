import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';

import '../Widgets/custom_container.dart';
import '../component/color.dart';
import '../pages/hospital_details.dart';

class ProviderState with ChangeNotifier {
  List<Marker> markers = [];
  List location = [];
  List category = [];
  List sliderData = [];
  bool search = false;
  bool slider = false;
  bool result = false;
  LocationPermission? val;
  double? lat;
  double? long;

  void changeState() {
    search = !search;
    notifyListeners();
  }

  getData(String id) async {
    String url =
        'https://ibtikarsoft.net/mapapi/categories.php?lang=en&cat=$id';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      List data = json.decode(res.body);
      if (data.isNotEmpty) {
        category = data;
        notifyListeners();
      }
      return data;
    } else {
      print("Error");
    }
  }

  getSliderData(String id, double lat, double long) async {
    String url =
        'https://ibtikarsoft.net/mapapi/map_slider.php?lang=ar&lat=$lat&long=$long&cat=$id';
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      sliderData = data;
      notifyListeners();
      print('**********************************');
      print(sliderData);
      notifyListeners();
      return data;
    } else {
      print("Error");
    }
  }

  getMarkers(String id, double lat, double long) async {
    String url =
        'https://ibtikarsoft.net/mapapi/map_markers.php?lang=ar&lat=$lat&long=$long&cat=$id';
    final res = await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        var data = json.decode(value.body);
        location = data;
        notifyListeners();
        markers.clear();
        location.forEach((element) {
          markers.add(Marker(
            width: 50,
            height: 50,
            point: LatLng(
                double.parse(element['lat']), double.parse(element['long'])),
            builder: (ctx) => CustomPaint(
              painter: Chevron(),
              child: Icon(
                IconDataSolid(int.parse(element['icon_name'])),
                color: HexColor.fromHex(element['color']),
                size: 25.0,
              ),
            ),
          ));
        });
        markers.add(Marker(
          width: 50,
          height: 50,
          point: LatLng(lat, long),
          builder: (ctx) => const Icon(
            FontAwesomeIcons.locationDot,
            color: Colors.redAccent,
            size: 35.0,
          ),
        ));
        notifyListeners();
      }
    });
  }

  Future<Position?> checkLocation() async {
    Geolocator.checkPermission().then((value) {
      print(value);
      if (value == LocationPermission.denied) {
        Geolocator.requestPermission().then((value) {
          if (value == LocationPermission.denied) {
            print("denied");
          } else if (value == LocationPermission.whileInUse) {
            print('go ');
            val = LocationPermission.whileInUse;
            getCurrentLocation();
            notifyListeners();
          } else {
            // getCurrentLocation();
          }
        });
      } else {
        getCurrentLocation();
      }
    });
    notifyListeners();
    return null;
  }

  Future<Position?> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    Position? lastPsition = await Geolocator.getLastKnownPosition();
    print('*------*------------------*************-----------*******--------');
    print(lastPsition?.latitude);
    print(lastPsition?.longitude);
    lat = lastPsition!.latitude;
    long = lastPsition.longitude;
    getMarkers('0', lat!, long!);
    getData('0');
    getSliderData('0', lat!, long!);
    notifyListeners();
    return lastPsition;
    // locationMessage="$position.latitude ,$position.longitude";
  }

  void checkEnternet() async {
    bool result1 = await InternetConnectionChecker().hasConnection;
    if (result1 == true) {
      print('Connection Done');
    } else {
      print('Connection failed');
    }
    result = result1;
    notifyListeners();
  }

  void changeSlider() {
    slider = !slider;
    notifyListeners();
  }

  void change(lat1,long1) {
    lat = lat1;
    long =long1;
     getSliderData('0', lat1!, long1!);
    notifyListeners();
  }
}
