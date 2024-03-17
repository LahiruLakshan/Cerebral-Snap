import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:permission_handler/permission_handler.dart';

import '../theme/app_theme.dart';

class Recorder extends StatefulWidget {
  const Recorder({Key? key}) : super(key: key);

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> {
  final recorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    initRecorder();
  }

  @override
  void dispose() {
    recorder.closeRecorder();

    super.dispose();
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if(status != PermissionStatus.granted){
       throw 'Microphone permission not granted';
    }
  }
  Future record() async{
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async{
    await recorder.stopRecorder();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Disease Prediction", style: TextStyle(color: AppTheme.colors.blue),),
        backgroundColor: AppTheme.colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ElevatedButton(
            onPressed: () async{
              if(recorder.isRecording){
                await stop();
              } else{
                await record();
              }

              setState(() {

              });
            },
            child: Icon(recorder.isRecording ? Icons.stop:Icons.mic,
            size: 80,),
          ),
        ),
      ),
    );
  }
}
