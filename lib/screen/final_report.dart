import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import 'loading_screen.dart';
class FinalReport extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;
  const FinalReport({Key? key, this.currentUser}) : super(key: key);

  @override
  State<FinalReport> createState() => _FinalReportState();
}

class _FinalReportState extends State<FinalReport> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _tumorRecordsStream = FirebaseFirestore.instance
        .collection('tumor_record')
        .orderBy("timeStamp", descending: true)
        .where("userId", isEqualTo: widget.currentUser!.id)
        .snapshots();

    final Stream<QuerySnapshot> _dysarthriaRecordsStream = FirebaseFirestore.instance
        .collection('audio_record')
        .orderBy("timeStamp", descending: true)
        .where("userId", isEqualTo: widget.currentUser!.id)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text("Brain Tumor", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
        iconTheme: IconThemeData(
          color: AppTheme.colors.blue, //change your color here
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),

                    Text(
                      "User ID : ${widget.currentUser!.id}",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,

                    ),
                    Text(
                      "Email : ${widget.currentUser!.get("email")}",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    Text(
                      "Brain Tumor Analysis",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Report - MRI",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: 80,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _tumorRecordsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingScreen();
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            );
                          }
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> recordData = snapshot.data!.docs;

                            if(recordData.length != 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cerebral Palsy Prediction : ${recordData[0]["tumorDetection"] == "Yes" ? "Positive":"Negative"}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "Prediction : ${recordData[0]["probability"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),Text(
                                    "Tumor Category : ${recordData[0]["tumorCategory"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),Text(
                                    "Updated At : ${DateFormat('dd-MM-yyyy   HH:mm').format(recordData[0]["timeStamp"].toDate())}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              );
                            }

                            if(recordData.isEmpty) {
                              return Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ));
                            }


                          }
                          return Container(width:300,child: CircularProgressIndicator(color: AppTheme.colors.blue));
                        },
                      ),
                    ),


                  ],
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),


                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    Text(
                      "Dysarthria Analysis",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Report - Audio Processing",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: 200,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _dysarthriaRecordsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingScreen();
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            );
                          }
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> recordData = snapshot.data!.docs;

                            if(recordData.length != 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cerebral Palsy Prediction : ${recordData[0]["dysarthriaDetection"] == "Dysarthria" ? "Positive":"Negative"}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "Prediction : ${recordData[0]["probability"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),Text(
                                    "Updated At : ${DateFormat('dd-MM-yyyy   HH:mm').format(recordData[0]["timeStamp"].toDate())}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              );
                            }

                            if(recordData.isEmpty) {
                              return Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ));
                            }


                          }
                          return Container(width:300,child: CircularProgressIndicator(color: AppTheme.colors.blue));
                        },
                      ),
                    ),


                  ],
                ),
              ),

              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30.0),


                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    Text(
                      "Game Analysis",
                      style: TextStyle(
                        fontSize: 18.0,
                        color: AppTheme.colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Divider(
                      color: AppTheme.colors.blue,
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      "Report - Audio Processing",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: AppTheme.colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      height: 200,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _dysarthriaRecordsStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return LoadingScreen();
                          }
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.white,
                                  )),
                            );
                          }
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> recordData = snapshot.data!.docs;

                            if(recordData.length != 0) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Cerebral Palsy Prediction : ${recordData[0]["dysarthriaDetection"] == "Dysarthria" ? "Positive":"Negative"}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Text(
                                    "Prediction : ${recordData[0]["probability"]}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),Text(
                                    "Updated At : ${DateFormat('dd-MM-yyyy   HH:mm').format(recordData[0]["timeStamp"].toDate())}",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: AppTheme.colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ],
                              );
                            }

                            if(recordData.isEmpty) {
                              return Text("Data not found!",
                                  style: TextStyle(
                                    color: Colors.black,
                                  ));
                            }


                          }
                          return Container(width:300,child: CircularProgressIndicator(color: AppTheme.colors.blue));
                        },
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
