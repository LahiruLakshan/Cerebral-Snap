import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button_icon.dart';

class GamesHome extends StatefulWidget {
  final  DocumentSnapshot<Object?>? currentUser;
  const GamesHome({Key? key, this.currentUser}) : super(key: key);

  @override
  State<GamesHome> createState() => _GamesHomeState();
}

class _GamesHomeState extends State<GamesHome> {
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
        title: Text("Games Analysis", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: ()  {
                    DeviceApps.openApp('com.example.bricks_breaker');
                  },
                  title: "Bricks Breacker",
                  fontSize: 18.0,
                  icon: const FaIcon(FontAwesomeIcons.bowlingBall,
                      size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  width: 200,
                  borderRadius: 10,
                ),
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) =>
                    //           Recorder()),
                    // );
                  },
                  title: "Flappy Bird",
                  fontSize: 18.0,
                  icon:
                  const FaIcon(FontAwesomeIcons.kiwiBird, size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  width: 200,
                  borderRadius: 10,
                ),
                const SizedBox(height: 30.0),


              ],
            ),
          ),
        ),
      ),
    );
  }

  // void handleUploadImage(File uploadImage) async {
  //   final request = http.MultipartRequest("POST", Uri.parse(uri));
  //   final headers = {"Content-type": "multipart/form-data"};
  //
  //   request.files.add(http.MultipartFile(
  //       'audio',
  //       uploadImage.readAsBytes().asStream(),
  //       uploadImage.lengthSync(),
  //       filename: uploadImage.path.split("/").last
  //   ));
  //
  //   request.headers.addAll(headers);
  //   final response = await request.send();
  //   http.Response res = await http.Response.fromStream(response);
  //   final resJson = jsonDecode(res.body);
  //   print("Response => $resJson");
  //   setState(() {
  //     responseList = resJson;
  //     isLoading = false;
  //     isPredictionFinish = true;
  //   });
  //   print("prediction => ${responseList["prediction"]}");
  // }
}
