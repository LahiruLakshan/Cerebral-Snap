import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart';
import 'loading_screen.dart';

class TumorRecords extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;

  const TumorRecords({Key? key,  this.currentUser}) : super(key: key);

  @override
  State<TumorRecords> createState() => _TumorRecordsState();
}

class _TumorRecordsState extends State<TumorRecords> {
  final _pageCtrl = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double height = screenSize - kToolbarHeight - 90.0;

    final Stream<QuerySnapshot> _recordsStream = FirebaseFirestore.instance
        .collection('tumor_record')
        .where("userId", isEqualTo: widget.currentUser!.id)
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text("Tumor Records", style: TextStyle(color: AppTheme.colors.blue),),
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
        child: StreamBuilder<QuerySnapshot>(
          stream: _recordsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("some error occured",
                    style: TextStyle(
                      color: Colors.white,
                    )),
              );
            }
            if (snapshot.hasData) {
              final List<DocumentSnapshot> recordData = snapshot.data!.docs;


              return Stack(
                children: [
                  ListView.builder(
                      controller: _pageCtrl,
                      itemCount: recordData?.length,
                      itemBuilder: (context, index) {
                        // var travel = _list[index];
                        final tumorRecord = recordData![index];
                        if(recordData.isNotEmpty){
                          return GestureDetector(
                            onTap: () {

                            },
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0),
                                  height: 170.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colors.blue,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Padding(
                                    padding:
                                    EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          // width: 120.0,
                                          child: Flexible(
                                            child: Text(
                                              "Detection : ${tumorRecord["tumorDetection"]}",
                                              style: TextStyle(
                                                fontSize: 18.0,
                                                color: AppTheme.colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Container(
                                          // width: 120.0,
                                          child: Flexible(
                                            child: Text(
                                              "Probability : ${tumorRecord["probability"]}",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppTheme.colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Container(
                                          // width: 120.0,
                                          child: Flexible(
                                            child: Text(
                                              "Tumor Category : ${tumorRecord["tumorCategory"]}",
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: AppTheme.colors.white,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                        Flexible(
                                          child: Text(
                                            "${DateFormat('dd-MM-yyyy   HH:mm').format(tumorRecord["timeStamp"].toDate())}",
                                            style: TextStyle(
                                              color: AppTheme.colors.grey200,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 10.0),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 20.0,
                                  top: 15.0,
                                  bottom: 15.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: CachedNetworkImage(
                                      imageUrl: "${tumorRecord["url"]}",
                                      width: 110.0,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const LoadingScreen(),
                                      errorWidget: (context, url, error) => Image.asset('assets/images/logo.png', fit: BoxFit.cover,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else{
                          return Center(
                            child: Text(
                                "Empty!"
                            ),
                          );
                        }

                      }),
                ],
              );
            }
            return LoadingScreen();
          },
        ),
      ),
    );
  }
}
