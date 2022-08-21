import 'package:flutter/material.dart';
import 'package:leafleet_map/pages/splash.dart';
import 'package:leafleet_map/provider/provider.dart';
import 'package:provider/provider.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ProviderState>(context);

    if (pro.result && pro.lat != null) {
      return const SplashView();
    } else {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    }
  }
}
