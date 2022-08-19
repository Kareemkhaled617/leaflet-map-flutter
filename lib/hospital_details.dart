import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'component/to_map.dart';

class HospitalDetails extends StatefulWidget {
  HospitalDetails({
    Key? key,
    required this.data,
    required this.id,
    required this.url,
    required this.name,
    required this.phone,
    required this.rate,
    required this.lat,
    required this.lang,
    required this.address,
  }) : super(key: key);
  List data = [];
  String id;
  String url;
  String address;
  String name;
  String phone;
  int rate;
  double lat;
  double lang;

  @override
  _HospitalDetailsState createState() => _HospitalDetailsState();
}

class _HospitalDetailsState extends State<HospitalDetails> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = widget.data;
    List<Widget> listItems = [];
    responseList.forEach((post) {
      listItems.add(Container(
          height: 180,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
              ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      post["name"],
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post["brand"],
                      style: const TextStyle(fontSize: 17, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
                Image.asset(
                  "${post["image"]}",
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )
              ],
            ),
          )));
    });
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              icon: Icon(
                FontAwesomeIcons.arrowLeft,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: <Widget>[
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: IconButton(
                icon: Icon(
                  FontAwesomeIcons.phone,
                  color: Colors.grey.shade700,
                ),
                onPressed: () {
                  launchUrl(Uri.parse('tel:/${widget.phone}'));
                },
              ),
            )
          ],
        ),
        body: SizedBox(
          width: double.infinity,
          height: size.height,
          child: Column(
            children: <Widget>[
              const Text(
                " Center",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(15),
                  // image: DecorationImage(
                  //     image: AssetImage(widget.url), fit: BoxFit.cover),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 180,
                      height: 300,
                      margin: const EdgeInsets.only(right: 13),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24.0),
                        child: const Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no"),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.name,
                          style: GoogleFonts.aleo(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text(
                            widget.address,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600
                            ),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Center(
                                  child: Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.yellowAccent,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rating',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '${widget.rate} out of 5',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Card(
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(12),
                                  child: Icon(
                                    FontAwesomeIcons.users,
                                    color: Colors.purple,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              children: const [
                                Text(
                                  'Patient',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '+1000',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: size.width,
                    alignment: Alignment.topCenter,
                    height: closeTopContainer ? 0 : categoryHeight,
                    child: CategoriesScroller(
                      widget.id,
                      address: widget.address,
                      lat: widget.lat,
                      long: widget.lang,
                    )),
              ),
              Expanded(
                child: ListView.builder(
                    controller: controller,
                    itemCount: itemsData.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      double scale = 1.0;
                      if (topContainer > 0.5) {
                        scale = index + 0.5 - topContainer;
                        if (scale < 0) {
                          scale = 0;
                        } else if (scale > 1) {
                          scale = 1;
                        }
                      }
                      return Opacity(
                        opacity: scale,
                        child: Transform(
                          transform: Matrix4.identity()..scale(scale, scale),
                          alignment: Alignment.bottomCenter,
                          child: Align(
                              heightFactor: 0.7,
                              alignment: Alignment.topCenter,
                              child: itemsData[index]),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: const Icon(Icons.chat_bubble),
          onPressed: () {},
        ),
      ),
    );
  }
}

class CategoriesScroller extends StatefulWidget {
  CategoriesScroller(
    this.id, {
    Key? key,
    required this.address,
    required this.lat,
    required this.long,
  }) : super(key: key);
  String id;
  String address;
  double lat;
  double long;

  @override
  State<CategoriesScroller> createState() => _CategoriesScrollerState();
}

class _CategoriesScrollerState extends State<CategoriesScroller> {
  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Container(
            width: 350,
            margin: const EdgeInsets.only(right: 20),
            height: categoryHeight,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Biography',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    '"Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
                    style: TextStyle(fontSize: 15),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.locationDot,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              MapUtils.map(widget.lat, widget.long);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
