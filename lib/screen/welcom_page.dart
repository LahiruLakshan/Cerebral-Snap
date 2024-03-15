import 'package:cerebral_snap/screen/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';
import 'login.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('pending');
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;

  void validate() {
    setState(() {
      check = true;
    });
    if (formKey.currentState!.validate()) {
      signIn(email.text.trim(), password.text.trim());
    } else {
      EasyLoading.showInfo("Login Failed!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Form(
                autovalidateMode: check
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                key: formKey,
                child: Column(
                  children: [
                    Image.asset('assets/images/logo.png', width: 200),
                    //email textfield
                    Container(
                      margin: EdgeInsets.only(top: 100),
                      child: Text("Welcome",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 34,
                              color: Color(0xff252525))),
                    ),

                    //Sign In button
                    AppElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                                return const Login();
                              }));
                        },
                        title: "Sign In",
                        top: 20,
                        left: 36.0,
                        right: 36.0,
                        primary: AppTheme.colors.blue,
                        onPrimary: AppTheme.colors.white,
                        bottom: 30.0),

                    //Sign In button
                    AppElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SignUp();
                          }));
                        },
                        title: "Sign Up",
                        left: 36.0,
                        right: 36.0,
                        borderColor: AppTheme.colors.blue,
                        primary: AppTheme.colors.white,
                        onPrimary: AppTheme.colors.blue,
                        bottom: 30.0),

                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  appleLogin() {}

  googleLogin() {}

  @override
  void initState() {
    super.initState();
  }

  Future signIn(String email, String password) async {
    EasyLoading.show(status: "Loading...");
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final User currentUser = FirebaseAuth.instance.currentUser!;
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('user')
          .doc(currentUser.uid)
          .get();

      if (doc.data() != null) {
        await FirebaseMessaging.instance.deleteToken();
        final mToken = await FirebaseMessaging.instance.getToken();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(currentUser.uid)
            .update({'mToken': mToken});
        if (doc.get("adminApproval")) {
          EasyLoading.showSuccess("Login Successfully!");
        } else {
          EasyLoading.showInfo("Admin Approval Needed!");
        }
      } else {
        //This location needed to remove current user data in email login
        EasyLoading.showInfo("Data Empty!");
      }
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Login Successfully!')),
      // );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError("User Not Found!");
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError("Wrong Password!");
      }
    }
    EasyLoading.dismiss();
  }
}
