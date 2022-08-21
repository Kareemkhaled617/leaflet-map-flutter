import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:leafleet_map/provider/provider.dart';
import 'package:provider/provider.dart';

import '../component/text_field.dart';
import '../component/to_map.dart';
import 'hospital_details.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    var x = Provider.of<ProviderState>(context);
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              controller: mapController,
              onPositionChanged: (position, hasGesture) {
                x.change(position,hasGesture );
              },
              plugins: [
                MarkerClusterPlugin(),
                const LocationMarkerPlugin(),
              ],
              center: LatLng(x.lat!, x.long!),
              // center: LatLng(30.4203482, 31.0699247),
              zoom: 12.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayerOptions(markers: x.markers),
            ],
          ),
          Container(
            height: 240,
            decoration: const BoxDecoration(color: Colors.transparent),
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              x.getData('0');
                              // x.getMarkers('0');
                            },
                            icon: const Icon(
                              FontAwesomeIcons.arrowLeft,
                              size: 25,
                              color: Colors.red,
                            )),
                      ),
                    ),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              x.changeState();
                            },
                            icon: const Icon(
                              FontAwesomeIcons.magnifyingGlassLocation,
                              size: 25,
                              color: Colors.red,
                            )),
                      ),
                    ),
                  ],
                ),
                x.search
                    ? buildTextFormField(
                        hint: '',
                        label: '',
                        pIcon: const Icon(
                          FontAwesomeIcons.locationDot,
                          size: 25,
                          color: Colors.red,
                        ),
                        // sIcon: const Icon(FontAwesomeIcons.magnifyingGlass),
                        type: TextInputType.text,
                        validate: () {},
                        onSave: () {},
                      )
                    : Container(),
                const SizedBox(
                  height: 20,
                ),
                Container(
                    height: 40,
                    margin: const EdgeInsets.only(left: 15),
                    child: ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (context, index) => const SizedBox(
                        width: 15,
                      ),
                      scrollDirection: Axis.horizontal,
                      itemCount: x.category.length,
                      itemBuilder: (context, index) => ElevatedButton.icon(
                        onPressed: () {
                          x.getData(x.category[index]['id']);
                          // x.getMarkers(x.category[index]['id']);
                        },
                        icon: Icon(
                          IconDataSolid(
                              int.parse(x.category[index]['icon_name'])),
                        ),
                        label: Text(x.category[index]['name']),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.transparent),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(
                                        color: Colors.white)))),
                      ),
                    ))
              ],
            ),
          ),
          _buildContainer(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => x.getCurrentLocation(),
        backgroundColor: Colors.white,
        child: const Icon(
          FontAwesomeIcons.locationArrow,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget _buildContainer() {
    var p = Provider.of<ProviderState>(context);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async{
                // mapController.move(
                //     LatLng(30.41775030552584, 31.077784895896915), 13);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HospitalDetails(
                          url: 'assets/images/hospital1/z.jpg',
                          id: '20',
                          data: [
                            {
                              "name": p.sliderData[index]['name'],
                              "brand": "Protect your child with us",
                              "price": 2.99,
                              "image": "assets/images/hospital1/n1.jpg"
                            },
                            {
                              "name": p.sliderData[index]['name'],
                              "brand": "Your child is safe",
                              "price": 4.99,
                              "image": "assets/images/hospital1/n2.jpg"
                            },
                            {
                              "name": p.sliderData[index]['name'],
                              "brand": "The best baby care",
                              "price": 1.49,
                              "image": "assets/images/hospital1/n3.jpg"
                            },
                            {
                              "name": p.sliderData[index]['name'],
                              "brand": "24 hours service",
                              "price": 2.99,
                              "image": "assets/images/hospital1/n4.jpg"
                            },
                          ],
                          address: p.sliderData[index]['address'],
                          lang: double.parse(p.sliderData[index]['long']),
                          rate: p.sliderData[index]['rate'],
                          name: p.sliderData[index]['name'],
                          phone: p.sliderData[index]['phone'],
                          lat: double.parse(p.sliderData[index]['lat']),
                        )));
              },
              child: FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(24.0),
                    shadowColor: const Color(0x802196F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        SizedBox(
                          width: 180,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: const Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                  "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  p.sliderData[index]['name'],
                                  style: const TextStyle(
                                      color: Color(0xff6200ee),
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Row(
                                children: [
                                  Text(
                                    '${p.sliderData[index]['rate']}',
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                          height: 30,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: p.sliderData[index]
                                                ['rate'],
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              FontAwesomeIcons.solidStar,
                                              color: Colors.amber,
                                              size: 25.0,
                                            ),
                                          )),
                                      SizedBox(
                                          height: 30,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemCount: -(p.sliderData[index]
                                                    ['rate']) +
                                                5,
                                            //  itemCount: 5-int.parse(p.sliderData[index]['rate']),
                                            itemBuilder: (context, index) =>
                                                const Icon(
                                              FontAwesomeIcons.star,
                                              color: Colors.amber,
                                              size: 25.0,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              InkWell(
                                onTap: () {
                                  MapUtils.map(
                                      double.parse(p.sliderData[index]['lat']),
                                      double.parse(
                                          p.sliderData[index]['long']));
                                },
                                child: Card(
                                  child: Row(
                                    children: const [
                                      Icon(
                                        FontAwesomeIcons.locationArrow,
                                        size: 30,
                                        color: Colors.deepOrange,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 10.0),
                                        child: Text(
                                          '150 M',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              const Text(
                                "Closed \u00B7 Opens 17:00 Thu",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
          itemCount: p.sliderData.length,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
