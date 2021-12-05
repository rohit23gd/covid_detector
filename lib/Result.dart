// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
  @override
  Widget build(BuildContext context) {
    print("No problem till now5");
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
          margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: SafeArea(
              child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 20,
                  padding: const EdgeInsets.all(8),
                  margin: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 1),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent[100]),
                  child: Text(_result,
                      style: const TextStyle(
                        fontSize: 25,
                      )),
                ),
              ),
              Expanded(
                flex: 10,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
