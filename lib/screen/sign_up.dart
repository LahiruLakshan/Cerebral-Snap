import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../theme/app_theme.dart';
import '../validation/form_validation.dart';
import '../widgets/app_elevated_button.dart';
import '../widgets/app_text_field.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final CollectionReference _user =
  FirebaseFirestore.instance.collection('user');
  final districtState = GlobalKey<FormFieldState>();
  final divisionState = GlobalKey<FormFieldState>();
  String dropdownvalue = "";

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool check = false;

  void validate() {
    setState(() {
      check = true;
    });
    if (formKey.currentState!.validate()) {
      signUp(name.text.trim(), email.text.trim(), password.text.trim(), mobileNumber.text.trim());
    } else {
      EasyLoading.showInfo("Sing Up Failed!");
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

                    //email textfield
                    Container(
                      margin: const EdgeInsets.only(top: 75),
                      child: const Text("Sign Up Now",
                          style: TextStyle(
                              fontFamily: 'Roboto',
                              fontSize: 34,
                              color: Color(0xff252525))),
                    ),

                    //name textfield
                    AppTextField(
                        hitText: "Name",
                        fieldValue: name,
                        top: 30.0,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        validator: FormValidation.requiredValidator),

                    AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        hitText: "Email",
                        fieldValue: email,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        validator: FormValidation.emailValidator),

                    //mobile textfield
                    AppTextField(
                        hitText: "Mobile Number",
                        fieldValue: mobileNumber,
                        keyboardType: TextInputType.phone,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        validator: FormValidation.requiredValidator),

                    //password textfield
                    AppTextField(
                        hitText: "Password",
                        fieldValue: password,
                        bottom: 30.0,
                        left: 36.0,
                        right: 36.0,
                        obscureText: true,
                        validator: FormValidation.passwordValidator),

                    //login button
                    AppElevatedButton(
                        onPressed: () => validate(),
                        title: "Sign Up",
                        left: 36.0,
                        right: 36.0,
                        primary: AppTheme.colors.blue,
                        onPrimary: AppTheme.colors.white,
                        bottom: 30.0),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
  }

  Future signUp(String name, String email, String password, String mobileNumber) async {

    EasyLoading.show(status: "Loading...");
    try {
      UserCredential userCredential = await FirebaseAuth
          .instance
          .createUserWithEmailAndPassword(
          email: email,
          password: password);

      await _user
          .doc(userCredential.user!.uid)
          .set({
        "username": name,
        "email": email,
        "mobileNo": mobileNumber

      })
          .then((value) => EasyLoading.showSuccess(
          "Registration Successfully!").then((value) => Navigator.pop(context))

      )
          .catchError((error) =>
          EasyLoading.showError(
              "Registration Failed!")
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.showError("Registration Failed!");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError("Email Already Registered!");
        print(
            'The account already exists for that email.');
      }
    }
    EasyLoading.dismiss();
  }
}
