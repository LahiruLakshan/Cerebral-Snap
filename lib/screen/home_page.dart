import 'dart:io';
import 'package:cerebral_snap/screen/brain_tumor_home.dart';
import 'package:cerebral_snap/screen/dysarthria_home.dart';
import 'package:cerebral_snap/screen/games_home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/app_elevated_button_icon.dart';

class HomePage extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;

  const HomePage({Key? key, this.currentUser}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? uploadImage;

  @override
  Widget build(BuildContext context) {
    final providerUser = Provider.of<UserProvider>(context);
    double width = MediaQuery.of(context).size.width;

    final user = FirebaseAuth.instance.currentUser!;
    print("user---->   $user");
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        toolbarHeight: 90.0,
        leadingWidth: 100,
        leading: Container(
          // color: AppTheme.colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 500,
              height: 500,
            ),
          ),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(widget.currentUser!["username"],
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: AppTheme.colors.white)),
              Text(widget.currentUser!["email"],
                  style: TextStyle(
                      fontFamily: 'Roboto-Light',
                      fontSize: 14,
                      color: AppTheme.colors.white)),
            ],
          ),
          const SizedBox(width: 10.0),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              // width: 500,
              // height: 500,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: AppTheme.colors.white,
                  foregroundColor: AppTheme.colors.white,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User Profile!')),
                    );
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) {
                    //       return const ProfileScreen();
                    //     }));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: const AssetImage('assets/images/user_icon.png'),
                    backgroundColor: AppTheme.colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            opacity: 0.8,
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Column(
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppElevatedButtonIcon(
                        onPressed: () {
                          providerUser.currentUser = widget.currentUser;
                          print("User : ${widget.currentUser}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BrainTumorHome(
                                    currentUser: widget.currentUser)),
                          );
                        },
                        title: "Brain tumor prediction",
                        fontSize: 18,
                        icon: const FaIcon(FontAwesomeIcons.brain, size: 20),
                        primary: AppTheme.colors.blue,
                        onPrimary: AppTheme.colors.white,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 30.0),
                      AppElevatedButtonIcon(
                        onPressed: () {
                          providerUser.currentUser = widget.currentUser;
                          print("User : ${widget.currentUser}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DysarthriaHome(
                                    currentUser: widget.currentUser)),
                          );
                        },
                        title: "Dysarthria prediction",
                        fontSize: 18,
                        icon: const FaIcon(FontAwesomeIcons.waveSquare,
                            size: 20),
                        primary: AppTheme.colors.blue,
                        onPrimary: AppTheme.colors.white,
                        borderRadius: 10,
                      ),
                      const SizedBox(height: 30.0),
                      AppElevatedButtonIcon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GamesHome(
                                    currentUser: widget.currentUser)),
                          );
                        },
                        title: "Play Games",
                        fontSize: 18,
                        icon:
                            const FaIcon(FontAwesomeIcons.gamepad, size: 20),
                        primary: AppTheme.colors.blue,
                        onPrimary: AppTheme.colors.white,
                        borderRadius: 10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
