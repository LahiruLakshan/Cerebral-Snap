import 'dart:io';
import 'dart:convert';
import 'dart:io';
import 'package:cerebral_snap/screen/recorder.dart';
import 'package:cerebral_snap/screen/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button_icon.dart';

class DysarthriaHome extends StatefulWidget {
  final  DocumentSnapshot<Object?>? currentUser;
  const DysarthriaHome({Key? key, this.currentUser}) : super(key: key);

  @override
  State<DysarthriaHome> createState() => _DysarthriaHomeState();
}

class _DysarthriaHomeState extends State<DysarthriaHome> {
  File? uploadImage;
  String uri =
      "https://d00d-35-194-203-8.ngrok-free.app/predict";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Dysarthria Prediction", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 30.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppElevatedButtonIcon(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) =>
                        //           Recorder()),
                        // );
                      },
                      title: "${"Recoder"}",
                      fontSize: 18.0,
                      icon:
                      const FaIcon(FontAwesomeIcons.recordVinyl, size: 20),
                      primary: AppTheme.colors.blue,
                      onPrimary: AppTheme.colors.white,
                      width: (width - 30) / 2 - 15,
                      borderRadius: 10,
                    ),
                    AppElevatedButtonIcon(
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        final result = await FilePicker.platform.pickFiles();
                        if (result == null) return;
                        handleUploadImage(File(result.files.single.path!));
                        },
                      title: "${"Audio File"}",
                      fontSize: 18.0,
                      icon: const FaIcon(FontAwesomeIcons.fileAudio,
                          size: 20),
                      primary: AppTheme.colors.blue,
                      onPrimary: AppTheme.colors.white,
                      width: (width - 30) / 2 - 15,
                      borderRadius: 10,
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    // providerUser.currentUser = widget.currentUser;
                    // print("User : ${widget.currentUser}");
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => BrainTumorHome(currentUser: widget.currentUser)),
                    // );
                  },
                  title: "Records",
                  fontSize: 18,
                  icon: const FaIcon(FontAwesomeIcons.history,
                      size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  borderRadius: 10,
                ),
                if (isLoading!)
                  LoadingAnimationWidget.prograssiveDots(
                    color: AppTheme.colors.blue,
                    size: 100,
                  ),
                if (isPredictionFinish!)
                  Column(
                    children: [
                      Center(
                        child: Text(
                          "Prediction : ${responseList["prediction"]}",
                          style: TextStyle(
                            fontSize: 25,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
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
  }
}
