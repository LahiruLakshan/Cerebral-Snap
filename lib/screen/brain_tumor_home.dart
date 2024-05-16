import 'dart:io';

import 'package:cerebral_snap/screen/tumor_records.dart';
import 'package:cerebral_snap/screen/upload_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../theme/app_theme.dart';
import '../widgets/app_elevated_button_icon.dart';


class BrainTumorHome extends StatefulWidget {
  final  DocumentSnapshot<Object?>? currentUser;
  const BrainTumorHome({Key? key, this.currentUser}) : super(key: key);

  @override
  State<BrainTumorHome> createState() => _BrainTumorHomeState();
}

class _BrainTumorHomeState extends State<BrainTumorHome> {
  File? uploadImage;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Brain Tumor", style: TextStyle(color: AppTheme.colors.blue),),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppElevatedButtonIcon(
                      onPressed: () {
                        pickImage(ImageSource.camera).then((value) => {
                          if (value != null)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UploadedImage(
                                            uploadImage:
                                            uploadImage)),
                              )
                            }
                        });
                      },
                      title: "Camera",
                      fontSize: 18.0,
                      icon:
                      const FaIcon(FontAwesomeIcons.camera, size: 20),
                      primary: AppTheme.colors.blue,
                      onPrimary: AppTheme.colors.white,
                      width: (width - 30) / 2 - 15,
                      borderRadius: 10,
                    ),
                    AppElevatedButtonIcon(
                      onPressed: () {
                        pickImage(ImageSource.gallery).then((value) => {
                          if (value != null)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UploadedImage(
                                            uploadImage:
                                            uploadImage)),
                              )
                            }
                        });
                      },
                      title: "Gallery",
                      fontSize: 18.0,
                      icon: const FaIcon(FontAwesomeIcons.photoFilm,
                          size: 20),
                      primary: AppTheme.colors.blue,
                      onPrimary: AppTheme.colors.white,
                      width: (width - 30) / 2 - 15,
                      borderRadius: 10,
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                AppElevatedButtonIcon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TumorRecords(currentUser: widget.currentUser)),
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
