import 'dart:async';
import 'dart:io';

import 'package:bigas/onbording.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'package:url_launcher/url_launcher.dart';
import 'loading.dart';
import 'main.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class TfliteModel extends StatefulWidget {
  const TfliteModel({Key? key}) : super(key: key);

  @override
  _TfliteModelState createState() => _TfliteModelState();
}

class _TfliteModelState extends State<TfliteModel> {
  bool loading = false;
  String? borer = "";
  String? res;
  String? img, img1, img2, img3, img4;
  bool? trans = false;
  late File _image;
  late List _results;
  bool imageSelect = false;
  String? dscptn = "Take or upload a photo.";
  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String res;

    res = (await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt"))!;
    print("Models loading status: $res");
  }

  Future classifyImage(File image) async {
    final List? recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 1,
        threshold: 0.2,
        asynch: true);
    setState(() {
      _results = recognitions!;
      _image = image;
      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            drawer: Drawer(
              backgroundColor: Color.fromARGB(255, 50, 131, 53),
              child: ListView(padding: EdgeInsets.zero, children: [
                SizedBox(height: 40),

                //profile
                ListTile(
                  contentPadding: EdgeInsets.only(left: 20),
                  leading: Icon(Icons.send, size: 30, color: Colors.white),
                  title: const Text('Feedback',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  onTap: () async {
                    String email = '2018100294n@psu.palawan.edu.ph';
                    String subject = 'User Feedback';
                    String body = 'Hi!';

                    String emailUrl =
                        "mailto:$email?subject=$subject&body=$body";

                    if (await canLaunch(emailUrl)) {
                      await launch(emailUrl);
                    } else {
                      throw "Error occured sending an email";
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.only(left: 20),
                  leading: Icon(Icons.help, size: 30, color: Colors.white),
                  title: const Text('Guide',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).push(_onbording());
                  },
                ),
              ]),
            ),
            appBar: AppBar(
                foregroundColor: Colors.white,
                elevation: 0,
                centerTitle: true,
                backgroundColor: Color.fromARGB(255, 35, 143, 39),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'image/logo.png',
                      scale: 11,
                    ),
                    const Text(
                      "BIGAS",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                )),
            body: Container(
              decoration: BoxDecoration(color: Color.fromARGB(255, 6, 119, 65)),
              padding: EdgeInsets.all(0),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 30),
                  (imageSelect)
                      ? Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.all(20),
                              child: Image.file(_image)),
                        )
                      : Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Container(
                              height: 300,
                              width: 300,
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10)
                                  ],
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.all(20),
                              child: Center(
                                  child: Image.asset(
                                "image/img.png",
                                height: 300,
                                width: 400,
                              ))),
                        ),
                  SizedBox(height: 10),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: (imageSelect)
                          ? _results.map((result) {
                              setState(() {
                                loading = true;
                              });
                              res = result["label"].toString();

                              setState(() {
                                loading = false;
                              });
                              if (res == "0 Something went wrong!") {
                                setState(() {
                                  borer = "No result found!";
                                  img = null;
                                  img1 = null;
                                  img2 = null;
                                  img3 = null;
                                  img4 = null;

                                  dscptn =
                                      "Try again, paying attention to the hints";
                                });
                              } else if (res == "1 White Stem Borer") {
                                setState(() {
                                  img = "image/Cypermethrin.gif";
                                  img1 = "image/w1.jpg";
                                  img2 = "image/w2.jpg";
                                  img3 = "image/w3.jpg";
                                  img4 = "image/w4.jpg";

                                  borer = "White Stem Borer";
                                  dscptn =
                                      "      Rice stem borers belong to the lepidopteran family, and all of them may be eradicated using Cypermenthrin. It is best to apply the insecticide after two days of the egg hatching. They are exposed first in the morning.";
                                });
                              } else if (res == "2 Yellow Stem Borer") {
                                setState(() {
                                  img = "image/Cypermethrin.gif";
                                  img1 = "image/y1.png";
                                  img2 = "image/y2.jpg";
                                  img3 = "image/y3.jpg";
                                  img4 = "image/y4.jpg";

                                  borer = "Yellow Stem Borer";
                                  dscptn =
                                      "      Rice stem borers belong to the lepidopteran family, and all of them may be eradicated using Cypermenthrin. It is best to apply the insecticide after two days of the egg hatching. They are exposed first in the morning.";
                                });
                              } else if (res == "3 Rice Striped Stem Borer") {
                                setState(() {
                                  img = "image/Cypermethrin.gif";
                                  img1 = "image/r1.jpg";
                                  img2 = "image/r2.jpg";
                                  img3 = "image/r3.jpg";
                                  img4 = "image/r4.jpg";
                                  borer = 'Rice Striped Stem Borer';
                                  dscptn =
                                      "      Rice stem borers belong to the lepidopteran family, and all of them may be eradicated using Cypermenthrin. It is best to apply the insecticide after two days of the egg hatching. They are exposed first in the morning.";
                                });
                              } else if (res == "4 Pink Stem Borer") {
                                setState(() {
                                  img = "image/Cypermethrin.gif";
                                  img1 = "image/p1.jpg";
                                  img2 = "image/p2.jpg";
                                  img3 = "image/p3.jpg";
                                  img4 = "image/p4.jpg";
                                  borer = "Pink Stem Borer";
                                  dscptn =
                                      "      Rice stem borers belong to the lepidopteran family, and all of them may be eradicated using Cypermenthrin. It is best to apply the insecticide after two days of the egg hatching. They are exposed first in the morning.";
                                });
                              }
                              return const Text(
                                "",
                                style: TextStyle(fontSize: 1),
                              );
                            }).toList()
                          : [],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          "Upload from your gallery - ",
                          style: TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: Container(
                              padding: EdgeInsets.all(10),
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.green,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 10),
                                  ]),
                              child: Icon(
                                Icons.image,
                                color: Colors.white,
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10)
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "$borer",
                              style: GoogleFonts.lato(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.green),
                            ),
                            Text(
                              "$dscptn",
                              style: GoogleFonts.lato(
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.black),
                            ),
                            Divider(),
                            Row(
                              children: [
                                img == null
                                    ? const Text("")
                                    : Text(
                                        "How to manage stem borer",
                                        style: GoogleFonts.lato(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headlineMedium,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.normal,
                                            color: Colors.black),
                                      ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            img == null
                                ? const Text("")
                                : Text(
                                    "10–20 ml of Cypermenthrin for 16 liters of water",
                                    style: GoogleFonts.lato(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                img == null
                                    ? const Text("")
                                    : Flexible(
                                        child: Container(
                                          child: Text(
                                            '       2 days after the hatching of eggs is the best and proper timing to spray.',
                                            overflow: TextOverflow.fade,
                                            style: GoogleFonts.lato(
                                                textStyle: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                fontStyle: FontStyle.italic,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                img == null
                                    ? Text("")
                                    : Image.asset(
                                        '$img',
                                        height: 110,
                                        width: 110,
                                      )
                              ],
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10)
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Images",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.normal),
                                )
                              ],
                            ),
                            Divider(),
                            const SizedBox(height: 5),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  img1 == null
                                      ? const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Center(
                                                  child: InteractiveViewer(
                                                child: (Container(
                                                  height: 500,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              '$img1'),
                                                          fit: BoxFit.fill)),
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              child: const Icon(
                                                                  Icons.cancel),
                                                              onTap: () {
                                                                navigatorKey
                                                                    .currentState!
                                                                    .popUntil(
                                                                        (route) =>
                                                                            route.isFirst);
                                                              })
                                                        ])
                                                  ]),
                                                )),
                                              )),
                                            );
                                          },
                                          child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('$img1'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(width: 5),
                                  img2 == null
                                      ? const Icon(Icons.image,
                                          size: 80, color: Colors.grey)
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Center(
                                                  child: InteractiveViewer(
                                                child: (Container(
                                                  height: 500,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              '$img2'),
                                                          fit: BoxFit.fill)),
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              child: const Icon(
                                                                  Icons.cancel),
                                                              onTap: () {
                                                                navigatorKey
                                                                    .currentState!
                                                                    .popUntil(
                                                                        (route) =>
                                                                            route.isFirst);
                                                              })
                                                        ])
                                                  ]),
                                                )),
                                              )),
                                            );
                                          },
                                          child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('$img2'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(width: 5),
                                  img3 == null
                                      ? const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Center(
                                                  child: InteractiveViewer(
                                                child: (Container(
                                                  height: 500,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              '$img3'),
                                                          fit: BoxFit.fill)),
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              child: const Icon(
                                                                  Icons.cancel),
                                                              onTap: () {
                                                                navigatorKey
                                                                    .currentState!
                                                                    .popUntil(
                                                                        (route) =>
                                                                            route.isFirst);
                                                              })
                                                        ])
                                                  ]),
                                                )),
                                              )),
                                            );
                                          },
                                          child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('$img3'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                  const SizedBox(width: 5),
                                  img4 == null
                                      ? const Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey,
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => Center(
                                                  child: InteractiveViewer(
                                                child: (Container(
                                                  height: 500,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              '$img4'),
                                                          fit: BoxFit.fill)),
                                                  child: Column(children: [
                                                    Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          GestureDetector(
                                                              child: const Icon(
                                                                  Icons.cancel),
                                                              onTap: () {
                                                                navigatorKey
                                                                    .currentState!
                                                                    .popUntil(
                                                                        (route) =>
                                                                            route.isFirst);
                                                              })
                                                        ])
                                                  ]),
                                                )),
                                              )),
                                            );
                                          },
                                          child: Container(
                                            height: 80.0,
                                            width: 80.0,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('$img4'),
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            )
                          ],
                        )),
                  ),
                ]),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: _openImagePicker,
              tooltip: "Pick Image",
              child: const Icon(Icons.camera_alt_outlined),
            ),
          );
  }

  Route _onbording() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, anotherAnimation) => Onbording(),
      transitionDuration: const Duration(milliseconds: 1000),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (context, animation, anotherAnimation, child) {
        animation = CurvedAnimation(
            parent: animation,
            reverseCurve: Curves.fastOutSlowIn,
            curve: Curves.fastLinearToSlowEaseIn);

        return SlideTransition(
            position: Tween(
                    begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
                .animate(animation),
            child: Onbording());
      },
    );
  }

  Future<void> _openImagePicker() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    if (pickedImage != null) {
      File image = File(pickedImage.path);

      classifyImage(image);
    }
  }

  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File image = File(pickedFile.path);

      classifyImage(image);
    }
  }
}
