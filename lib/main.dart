// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:io';
import 'dart:ui';
import 'package:ai_covid_detector/Result.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'Result.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const splash_screen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title = 'Covid Detector';

  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _outputs;
  var _image;
  var path_img;
  var color_green;
  var upload_text = "Choose Image";
  bool uploaded = false;

  List<dynamic>? _output;
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
      color_green = Colors.white;
      uploaded = false;
    });
  }

  Color gradientStart = Color(0xFFEC33DE);
  Color gradientEnd = Color(0xFF490B45);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
            padding: EdgeInsets.only(left: 10),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFF6E40)),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo,
                          size: 45,
                          color: color_green,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                          onPressed: () async {
                            if (uploaded != true) {
                              await pickImage();
                              setState(() {
                                color_green = Colors.green;
                                uploaded = true;
                                upload_text = "Delete Image";
                                print(uploaded);
                              });
                            }
                          },
                          child: Text(
                            upload_text,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                        Visibility(
                            visible: uploaded,
                            child: IconButton(
                                iconSize: 30,
                                onPressed: () {
                                  setState(() {
                                    upload_text = "Choose Image";
                                    color_green = Colors.white;
                                    uploaded = false;
                                  });
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.blueGrey))),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (uploaded == true) {
                            setState(() {
                              uploaded = false;
                              color_green = Colors.white;
                              upload_text = "Choose Image";
                            });
                            await run_model();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => result_display(
                                      _output![0]['label'], File(_image.path))),
                            );
                          }
                        },
                        child: const Text(
                          "Start Analyzing ",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    var image = await _picker.getImage(source: ImageSource.gallery);
    _image = image;
  }

  // ignore: non_constant_identifier_names
  Future run_model() async {
    var output = await Tflite.runModelOnImage(
        imageMean: 0.0,
        imageStd: 255,
        asynch: true,
        threshold: 1,
        path: _image.path,
        numResults: 3);

    //print("predict = " + output.toString());
    _output = output;
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "asset/CNN_AI_Trained2.tflite",
        labels: "asset/label.txt",
        numThreads: 1);
  }
}
