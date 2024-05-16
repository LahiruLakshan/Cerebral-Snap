import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';
import 'tumor_treatment_page.dart';

class UploadedImage extends StatefulWidget {
  final File? uploadImage;

  const UploadedImage({Key? key, this.uploadImage}) : super(key: key);

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  String uri = "https://351a-34-74-143-44.ngrok-free.app/upload";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;

  @override
  Widget build(BuildContext context) {
    final CollectionReference _records =
        FirebaseFirestore.instance.collection('tumor_record');

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Brain Tumor Prediction",
          style: TextStyle(color: AppTheme.colors.blue),
        ),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: width,
                  margin: const EdgeInsets.only(
                      bottom: 30.0, left: 30.0, right: 30.0),
                  decoration:
                      widget.uploadImage == null || widget.uploadImage == true
                          ? BoxDecoration(color: AppTheme.colors.blue)
                          : BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(widget.uploadImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                ),
                const SizedBox(height: 16),
                if (isLoading! == false && isPredictionFinish! == false)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      print("isLoading => $isLoading");
                      print("Upload Image => ${widget.uploadImage}");
                      handleUploadImage(widget.uploadImage!);
                      // Navigator.pushNamed(context, UploadScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.colors.blue, // Dark blue
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(25), // Rounded button
                      ),
                    ),
                    child: const Text(
                      'Scan',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Use a different font
                      ),
                    ),
                  ),
                if (isLoading!)
                  LoadingAnimationWidget.prograssiveDots(
                    color: AppTheme.colors.blue,
                    size: 100,
                  ),
                if (isPredictionFinish! && responseList["status"] == "SUCCESS")
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Tumor Prediction : ${responseList["tumor_detection"]}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          "Probabilitie : ${(responseList["probabilities"][0] * 100).toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      if (responseList["tumor_category"] != "")
                        Center(
                          child: Text(
                            "Tumor Category : ${responseList["tumor_category"]}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.colors.blue, // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                        ),
                      AppElevatedButton(
                          onPressed: () async {
                            EasyLoading.show(status: "Loading...");
                            String url =
                                await uploadFile(widget.uploadImage!.path);
                            final user = FirebaseAuth.instance.currentUser!;

                            await _records
                                .add({
                                  "url": url,
                                  "userId": user.uid,
                                  "tumorDetection":
                                      responseList["tumor_detection"],
                                  "probability":
                                      "${(responseList["probabilities"][0] * 100).toStringAsFixed(2)}%",
                                  "tumorCategory":
                                      responseList["tumor_category"] == ""
                                          ? "N/A"
                                          : responseList["tumor_category"],
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
                      AppElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TumorTreatmentPage(
                                        category:
                                            responseList["tumor_category"])));
                          },
                          title: "Treatment",
                          primary: AppTheme.colors.blue,
                          bottom: 10,
                          onPrimary: AppTheme.colors.white),
                      AppElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          title: "Back to Home",
                          primary: AppTheme.colors.white,
                          onPrimary: AppTheme.colors.black)
                    ],
                  ),
                if (isPredictionFinish! && responseList["status"] == "ERROR")
                  Center(
                    child: Text(
                      "ERROR : ${responseList["error"]}",
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.red, // Dark blue
                        fontFamily: 'Raleway ', // Use a different font
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
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
        'image', uploadImage.readAsBytes().asStream(), uploadImage.lengthSync(),
        filename: uploadImage.path.split("/").last));

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
    print("tumor_detection => ${responseList["tumor_detection"]}");
    print("probabilities => ${responseList["probabilities"]}");
    print("tumor_category => ${responseList["tumor_category"]}");
  }

  Future<String> uploadFile(
    String filePath,
  ) async {
    File file = File(filePath);
    try {
      final storageRef = FirebaseStorage.instance.ref();

// Create a reference to "mountains.jpg"
      final mountainsRef =
          storageRef.child('images/${DateTime.timestamp().toString()}');
      await mountainsRef.putFile(
          file, SettableMetadata(contentType: 'image/png'));
      String downloadURL = await mountainsRef.getDownloadURL();

      return downloadURL;
    } on FirebaseException catch (e) {
      print(e);
    }
    return "";
  }
}
