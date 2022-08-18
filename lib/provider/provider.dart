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
import '../homa_page.dart';

class ProviderState with ChangeNotifier {
  List<Marker> markers = [];
  List location = [];
  List category = [];
  List sliderData = [];
  bool search = false;
  bool slider = false;

  void changeState() {
    search = !search;
    notifyListeners();
  }

  getData(String id) async {
    String url =
        'https://ibtikarsoft.net/mapapi/categories.php?lang=en&cat=$id';
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      category = data;
      notifyListeners();
      return data;
    } else {
      print("Error");
    }
  }
  getSliderData(String id) async {
    String url =
        'https://ibtikarsoft.net/mapapi/map_slider.php?lang=ar&lat=30.4203482&long=31.0699247&cat=$id';
    final res = await http.get(Uri.parse(url));

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      sliderData = data;
      print('**********************************');
      print(sliderData);
      notifyListeners();
      return data;
    } else {
      print("Error");
    }
  }

  getMarkers(String id) async {
    String url =
        'https://ibtikarsoft.net/mapapi/map_markers.php?lang=ar&lat=30.4203482&long=31.0699247&cat=$id';
    final res = await http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        var data = json.decode(value.body);
        location = data;
        markers.clear();
        location.forEach((element) {
          markers.add(Marker(
            width: 50,
            height: 50,
            point: LatLng(
                double.parse(element['lat']), double.parse(element['long'])),
            builder: (ctx) => InkWell(
              child: CustomPaint(
                painter: Chevron(),
                child: Icon(
                  IconDataSolid(int.parse(element['icon_name'])),
                  color: HexColor.fromHex(element['color']),
                  size: 25.0,
                ),
              ),
              onTap: () {
               changeSlider();
              },
            ),
          ));
        });

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
            getCurrentLocation();
          } else {
            getCurrentLocation();
          }
        });
      }
    });
    return null;
  }

  Future<Position?> getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPsition = await Geolocator.getLastKnownPosition();
    print(lastPsition?.latitude);
    print(lastPsition?.longitude);
    return lastPsition;
    // locationMessage="$position.latitude ,$position.longitude";
  }

  void checkEnternet() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      print('Connection Done');
    } else {
      print('Connection failed');
    }
    notifyListeners();
  }

  void changeSlider(){
    slider=!slider;
    notifyListeners();
  }
}
