// ignore_for_file: avoid_print, unnecessary_null_comparison, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:ai_covid_detector/Result.dart';
import 'package:ai_covid_detector/save.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as imager;
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'Result.dart';
import 'splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
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
  late imager.Image img3;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
            height: 200,
            padding: EdgeInsets.only(left: 10),
            margin: EdgeInsets.only(left: 15, right: 20),
            //Color(0xFFFF6E40)),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orange[700]),
                  child: Row(
                    children: [
                      Icon(
                        Icons.file_copy,
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
                              iconSize: 35,
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
                          });
                          await run_model();
                          print("No problem till now4");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => result_display(
                                    _output![0]['label'], File(path_img))),
                          );
                        }
                      },
                      child: const Text(
                        "Start Analyzing ",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      )),
                ),
              ],
            )),
      ),
    );
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    var image_ = await _picker.getImage(source: ImageSource.gallery);
    _image = image_;

    var img2 = imager.decodeImage(File(image_.path).readAsBytesSync());
    img2?.setPixel(180, 180, 3);
    img3 = imager.normalize(img2!, 0, 1);
    path_img = await save_img(img3);
  }

  // ignore: non_constant_identifier_names
  Future run_model() async {
    print("image is picked");

    var output = await Tflite.runModelOnImage(
        imageMean: 0.0,
        imageStd: 255,
        asynch: true,
        threshold: 1,
        path: path_img,
        numResults: 3);

    print("predict = " + output.toString());
    _output = output;
  }

  loadModel() async {
    print('i am here to load');
    await Tflite.loadModel(
        model: "asset/CNN_AI_Trained2.tflite",
        labels: "asset/label.txt",
        numThreads: 1);
    print('done loading');
  }
}
