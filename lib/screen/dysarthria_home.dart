import 'dart:io';

import 'package:cerebral_snap/screen/recorder.dart';
import 'package:cerebral_snap/screen/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Recorder()),
                        );
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
                        final result = await FilePicker.platform.pickFiles();
                        if (result == null) return;
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
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        uploadImage = imageTemporary;
      });

      return imageTemporary;
    } on PlatformException catch (e) {
      print("Failed ro pick image => $e");
    }
  }
}
