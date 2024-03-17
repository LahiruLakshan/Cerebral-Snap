import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button.dart';


class UploadedImage extends StatefulWidget {
  final File? uploadImage;

  const UploadedImage({Key? key, this.uploadImage}) : super(key: key);

  @override
  State<UploadedImage> createState() => _UploadedImageState();
}

class _UploadedImageState extends State<UploadedImage> {
  String uri =
      "https://a426-34-86-176-179.ngrok-free.app/upload";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Brain Tumor Prediction", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 200.0,
                  width: width,
                  margin:
                  EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
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
                SizedBox(height: 16),
                if (isLoading! == false && isPredictionFinish! == false)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                      });
                      print("isLoading => ${isLoading}");
                      print("Upload Image => ${widget.uploadImage}");
                      handleUploadImage(widget.uploadImage!);
                      // Navigator.pushNamed(context, UploadScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppTheme.colors.blue, // Dark blue
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
                      Center(
                        child: Text(
                          "Probabilitie : ${(responseList["probabilities"][0] * 100).toStringAsFixed(2)}%",
                          style: TextStyle(
                            fontSize: 20,
                            color: AppTheme.colors.blue, // Dark blue
                            fontFamily: 'Raleway ', // Use a different font
                          ),
                        ),
                      ),
                      AppElevatedButton(
                          onPressed: ()
                          {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           CausePage(
                            //               treatment: responseList["class"],
                            //               file: widget.uploadImage))),
                          },
                          title: "Treatment",
                          primary: AppTheme.colors.blue,
                          bottom: 10,
                          top: 20,
                          onPrimary: AppTheme.colors.white),
                      AppElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          title: "Cancel",
                          primary: AppTheme.colors.white,
                          onPrimary: AppTheme.colors.black)
                    ],
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
        'image',
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
    print("probabilities => ${responseList["probabilities"]}");
  }
}
