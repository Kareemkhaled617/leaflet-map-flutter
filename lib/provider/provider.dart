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
import '../hospital_details.dart';

class ProviderState with ChangeNotifier {
  List<Marker> markers = [];
  List location = [];
  List category = [];
  List sliderData = [];
  bool search = false;
  bool slider = false;
  bool result = false;

  double lat=30.4203482;
  double long=31.0699247;

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

  getMarkers(String id ) async {
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
                print(element['id']);
              // sliderData.firstWhere((element1) {
              //   if(element1['id']!=id){
              //     Navigator.of(ctx).push(MaterialPageRoute(
              //         builder: (context) => HospitalDetails(
              //           lang: double.parse(element1['long']),
              //           rate: element1['rate'],
              //           name: element1['name'],
              //           phone: element1['phone'],
              //           lat: double.parse(element1['lat']),
              //           url: 'assets/images/hospital1/z.jpg',
              //           id: '20',
              //           data:  [
              //             {
              //               "name": element1['name'],
              //               "brand": "Protect your child with us",
              //               "price": 2.99,
              //               "image": "assets/images/hospital1/n1.jpg"
              //             },
              //             {
              //               "name": element1['name'],
              //               "brand": "Your child is safe",
              //               "price": 4.99,
              //               "image": "assets/images/hospital1/n2.jpg"
              //             },
              //             {
              //               "name": element1['name'],
              //               "brand": "The best baby care",
              //               "price": 1.49,
              //               "image": "assets/images/hospital1/n3.jpg"
              //             },
              //             {
              //               "name": element1['name'],
              //               "brand": "24 hours service",
              //               "price": 2.99,
              //               "image": "assets/images/hospital1/n4.jpg"
              //             },
              //           ],
              //           address:
              //           'د. نشوة حسين العشرى - استشارى طب اطفال وحديثى الولادة والرضاعة الطبيعية',
              //         )));
              //   }
              //   return true;
              // });
              },
            ),
          ));

        });
        markers.add(Marker(
          width: 50,
          height: 50,
          point: LatLng(
              lat,long),
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
    Position? lastPsition = await Geolocator.getLastKnownPosition();
    print(lastPsition?.latitude);
    print(lastPsition?.longitude);
    lat=lastPsition!.latitude;

    long=lastPsition.longitude;
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
    result=result1;
    notifyListeners();
  }

  void changeSlider(){
    slider=!slider;
    notifyListeners();
  }
}
