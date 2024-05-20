import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_theme.dart';
import '../loading_screen.dart';

class GameRecordsPage extends StatefulWidget {
  final DocumentSnapshot<Object?>? currentUser;

  const GameRecordsPage({Key? key,  this.currentUser}) : super(key: key);

  @override
  State<GameRecordsPage> createState() => _GameRecordsPageState();
}

class _GameRecordsPageState extends State<GameRecordsPage> {
  final _pageCtrl = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.height;
    double height = screenSize - kToolbarHeight - 90.0;

    final Stream<QuerySnapshot> _recordsStream = FirebaseFirestore.instance
        .collection('game')
        .snapshots();

    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: AppBar(
        title: Text("Game Records", style: TextStyle(color: AppTheme.colors.blue),),
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
                                              "Brick Breaker : ${tumorRecord["brikeBrakerSec"]}",
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
                                              "Flappy Bird : ${tumorRecord["flappyBirdsec"]}",
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
                                              "Snake Game : ${tumorRecord["snakeGamesec"]}",
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
                                              "Situation : ${tumorRecord["situation"]}",
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


                                      ],
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
