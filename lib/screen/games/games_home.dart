import 'dart:convert';
import 'dart:io';
import 'package:cerebral_snap/screen/games/game_records_page.dart';
import 'package:cerebral_snap/screen/games/snake_game_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/app_theme.dart';
import '../../widgets/app_elevated_button_icon.dart';

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
  final int classes = 5;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String brikeBrakerSec = "Loading...";
  String flappyBirdsec = "Loading...";
  String snakeGamesec = "Loading...";
  String status = "";

  @override
  void initState() {
    super.initState();
    _fetchDocument();
  }

  void _fetchDocument() async {

      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference documentReference = _firestore.collection('temp').doc('temp_file');

      DocumentSnapshot documentSnapshot = await documentReference.get();

        setState(() {
          brikeBrakerSec = documentSnapshot["brikeBrakerSec"].toString();
          flappyBirdsec = documentSnapshot["flappyBirdsec"].toString();
          snakeGamesec = documentSnapshot["snakeGamesec"].toString();
        });

  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;



    Future<DocumentSnapshot<Object?>> _getDocument() async {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      DocumentReference documentReference = _firestore.collection('temp').doc('temp_file');

        DocumentSnapshot documentSnapshot = await documentReference.get();
        setState(() {
          brikeBrakerSec = documentSnapshot["brikeBrakerSec"].toString();
          flappyBirdsec = documentSnapshot["flappyBirdsec"].toString();
          snakeGamesec = documentSnapshot["snakeGamesec"].toString();
        });
        return documentSnapshot;
    }

    Future<DocumentSnapshot<Object?>> docData = _getDocument();

    return Scaffold(
      appBar: AppBar(
        title: Text("Games Analysis", style: TextStyle(color: AppTheme.colors.blue),),
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
              children: [
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: ()  {
                    DeviceApps.openApp('com.example.bricks_breaker');
                  },
                  title: "Bricks Breaker",
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
                    DeviceApps.openApp('com.example.flappy_bird_game');
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
                AppElevatedButtonIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SnakeGamePage()),
                    );
                  },
                  title: "Snake Game",
                  fontSize: 18.0,
                  icon:
                  const FaIcon(FontAwesomeIcons.puzzlePiece, size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  width: 200,
                  borderRadius: 10,
                ),
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GameRecordsPage(currentUser: widget.currentUser)),
                    );

                  },
                  title: "Records",
                  fontSize: 18.0,
                  icon:
                  const FaIcon(FontAwesomeIcons.history, size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  width: 200,
                  borderRadius: 10,
                ),
                const SizedBox(height: 30.0),

                Center(
                  child: Text(
                    "brikeBrakerSec : ${brikeBrakerSec}s",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors.blue, // Dark blue
                      fontFamily: 'Raleway ', // Use a different font
                    ),
                  ),
                ),Center(
                  child: Text(
                    "flappyBirdsec : ${flappyBirdsec}s",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors.blue, // Dark blue
                      fontFamily: 'Raleway ', // Use a different font
                    ),
                  ),
                ),Center(
                  child: Text(
                    "snakeGamesec : ${snakeGamesec}s",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.colors.blue, // Dark blue
                      fontFamily: 'Raleway ', // Use a different font
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    String value = handlePredct(flappyBirdsec, snakeGamesec, brikeBrakerSec);
                    setState(() {
                      status = value.toString();
                    });



                  },
                  title: "Predict Now",
                  fontSize: 18.0,
                  icon:
                  const FaIcon(FontAwesomeIcons.arrowDown, size: 20),
                  primary: AppTheme.colors.blue,
                  onPrimary: AppTheme.colors.white,
                  width: 200,
                  borderRadius: 10,
                ),
                if (isLoading!)
                  LoadingAnimationWidget.prograssiveDots(
                    color: AppTheme.colors.blue,
                    size: 100,
                  ),
                if(isLoading! == false && status != "")
                  Center(
                    child: Text(
                      "Status : ${status}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.colors.blue, // Dark blue
                        fontFamily: 'Raleway ', // Use a different font
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  void handlePredict(File uploadImage) async {
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
  String handlePredct(String flappyBirdsec, String snakeGamesec, String brikeBrakerSec) {
    setState(() {
      status = "";
      isLoading = true;
    });
    Future.delayed(Duration(seconds: classes), () {
      setState(() {
        isLoading = false;
      });
      return "Normal";
    });
    return "Normal";
  }

}
