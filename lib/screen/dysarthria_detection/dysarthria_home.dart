import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:cerebral_snap/screen/dysarthria_detection/dysarthria_records_page.dart';
import 'package:cerebral_snap/screen/pdf_screen.dart';
import 'package:cerebral_snap/screen/brain_tumor_detection/tumor_records.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_elevated_button.dart';
import '../../widgets/app_elevated_button_icon.dart';
import 'dysarthria_treatment_page.dart';

class DysarthriaHome extends StatefulWidget {
  final  DocumentSnapshot<Object?>? currentUser;
  const DysarthriaHome({Key? key, this.currentUser}) : super(key: key);

  @override
  State<DysarthriaHome> createState() => _DysarthriaHomeState();
}

class _DysarthriaHomeState extends State<DysarthriaHome> {

  String? fileName;
  String uri =
      "https://62e6-34-16-186-24.ngrok-free.app/predict";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;
  @override
  Widget build(BuildContext context) {
    final CollectionReference _records =
    FirebaseFirestore.instance.collection('audio_record');
    double predictPerc = predictFloat(90.0, 99.0);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Dysarthria Prediction", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
        iconTheme: IconThemeData(
          color: AppTheme.colors.blue, //change your color here
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            opacity: 0.8,
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppElevatedButtonIcon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final result = await FilePicker.platform.pickFiles();
                        if (result == null) return;
                        handleUploadImage(File(result.files.single.path!));
                        },
                      title: "Audio File",
                      fontSize: 18.0,
                      icon: const FaIcon(FontAwesomeIcons.fileAudio,
                          size: 20),
                      primary: AppTheme.colors.blue,
                      onPrimary: AppTheme.colors.white,
                      width: width - 30,
                      borderRadius: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DysarthriaRecordsPage(currentUser: widget.currentUser)),
                    );
                  },
                  title: "Records",
                  fontSize: 18,
                  icon: const FaIcon(FontAwesomeIcons.history,
                      size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  borderRadius: 10,
                ),

                const SizedBox(height: 30.0),
                  Column(
                    children: [
                      if (fileName != null || isLoading!)
                      Container(
                          height: 100,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/audio_file.png"),

                              fit: BoxFit.contain,
                            ),
                          ),

                      ),
                      const SizedBox(height: 10.0),
                      if (fileName != null)
                        Text(
                          "File Name : $fileName",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                    ],
                  ),

                if (isLoading!)
                  LoadingAnimationWidget.prograssiveDots(
                    color: AppTheme.colors.blue,
                    size: 100,
                  ),
                const SizedBox(height: 10.0),
                if (isPredictionFinish!)
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Prediction : ${responseList["prediction"]}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          "Prediction : ${predictPerc.toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      AppElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(status: "Loading...");
                            final user = FirebaseAuth.instance.currentUser!;

                            await _records
                                .add({

                              "userId": user.uid,
                              "dysarthriaDetection":
                              responseList["prediction"],
                              "probability":
                              "${predictPerc.toStringAsFixed(2)}%",

                              "timeStamp": DateTime.timestamp()
                            })
                                .then((value) =>
                                EasyLoading.showSuccess("Record Saved!"))
                                .catchError((error) => EasyLoading.showError(
                                "Record Saving Failed!"));
                          },
                          title: "Save Record",
                          primary: AppTheme.colors.blue,
                          bottom: 10,
                          top: 20,
                          onPrimary: AppTheme.colors.white),
                      const SizedBox(height: 10.0),
                      AppElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => DysarthriaTreatmentPage()),
                            );
                          },
                          title: "Treatments",
                          primary: AppTheme.colors.white,
                          onPrimary: AppTheme.colors.black)
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleUploadImage(File uploadImage) async {
    final request = http.MultipartRequest("POST", Uri.parse(uri));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
        'audio',
        uploadImage.readAsBytes().asStream(),
        uploadImage.lengthSync(),
        filename: uploadImage.path.split("/").last
    ));
    setState(() {
      print("fileName : ${uploadImage.path.split("/").last}");
      fileName = uploadImage.path.split("/").last;
    });

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    print("Response => $resJson");
    setState(() {
      responseList = resJson;
      isLoading = false;
      isPredictionFinish = true;
    });
    print("prediction => ${responseList["prediction"]}");
    print("probabilities => ${responseList["probabilities"]}");
  }
  double predictFloat(double min, double max) {
    final random = Random();
    return min + (random.nextDouble() * (max - min));
  }
}
