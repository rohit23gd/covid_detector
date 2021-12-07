// ignore_for_file: file_names, prefer_const_constructors, import_of_legacy_library_into_null_safe

import 'dart:io';

import 'package:flutter/material.dart';

class result_display extends StatefulWidget {
  result_display(this._result, this.image);
  final String _result;
  File image;
  @override
  State<StatefulWidget> createState() => display_result(_result, image);
}

// ignore: camel_case_types
class display_result extends State<StatefulWidget> {
  display_result(this._result, this.image);
  final String _result;
  File image;
  Color gradientStart = Color(0xFFEC33DE);
  Color gradientEnd = Color(0xFF490B45);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Color(0xFF01579B),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('X-Ray Result'),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStart, gradientEnd],
                begin: const FractionalOffset(0.5, 0.0),
                end: const FractionalOffset(0.0, 0.5),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          //margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SafeArea(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  height: 40,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(left: 30, right: 30, top: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green[800]),
                  child: Text(_result,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                flex: 12,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Image.file(image, fit: BoxFit.fill),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }
}
