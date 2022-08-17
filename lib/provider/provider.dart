import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:latlong2/latlong.dart';

import '../Widgets/custom_container.dart';
import '../homa_page.dart';

class ProviderState with ChangeNotifier {
  List<Marker> markers = [];
  List location = [];
  List category = [];
  bool search = false;

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
      print('**********************************');
      print(category);
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
      print(value.body);
      if (value.statusCode == 200) {
        var data = json.decode(value.body);
        location = data;
        print('-----------------------------');
        print(location);
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
                showModalBottomSheet(
                    context: ctx,
                    builder: (builder) {
                      return Container(
                        height: 350.0,
                        color: Colors.transparent,
                        //could change this to Color(0xFF737373),
                        //so you don't have to change MaterialApp canvasColor
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  topRight: Radius.circular(10.0))),
                        ),
                      );
                    });
              },
            ),
          ));
        });
        print('----------');
        print(markers);
        print('----------');
        notifyListeners();

        print(data);
      }
    });

    // if (res.statusCode == 200) {
    //   var data = json.decode(res.body);
    //   for (int i in data) {
    //     location = data;
    //     print(data);
    //     markers.add(Marker(
    //       point: LatLng(
    //           double.parse(data[i]['lat']), double.parse(data[i]['long'])),
    //       builder: (ctx) => Container(
    //         key: const Key('blue'),
    //         child: const Icon(
    //           Icons.location_on,
    //           color: Colors.red,
    //           size: 30.0,
    //         ),
    //       ),
    //     ));
    //
    //     print(markers);
    //     notifyListeners();
    //     print('----------------');
    //     print(data);
    //     print('----------------------');
    //     return data;
    //   }
    // } else {
    //   print("Error");
    // }
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
}
