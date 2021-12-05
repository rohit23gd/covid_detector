// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'main.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({Key? key}) : super(key: key);

  @override
  _screen createState() => _screen();
}

class _screen extends State<splash_screen> {
  @override
  void initState() {
    super.initState();

    _navigator();
  }

  void _navigator() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        child: Image.asset(
          "asset/spash_image.PNG",
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
