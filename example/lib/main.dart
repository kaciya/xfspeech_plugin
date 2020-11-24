import 'package:flutter/material.dart';
import 'dart:async';
import 'package:xf_speech_plugin/xf_speech_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String iflyResultString = '点击+开始，点击-结束';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    final voice = XfSpeechPlugin.instance;
    voice.initWithAppId(iosAppID: '5d91c3c4', androidAppID: '5d91c3c4');
    final param = new XFVoiceParam();
    param.domain = 'iat';
    param.asr_ptt = '0';
    param.asr_audio_path = 'xme.pcm';
    param.result_type = 'plain';
    //param.voice_name = 'vixx';
    //param.voice_name = 'xiaoyan';
    //param.voice_name = 'aisxping';
    param.voice_name = 'aisjinger';

    voice.setParameter(param.toMap());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            child: Text(iflyResultString),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FloatingActionButton(
              onPressed: onTapDown,
              tooltip: 'Increment',
              child: Icon(Icons.play_arrow),
            ),
          ],
        ),
      ),
    );
  }

  onTapDown() {
    iflyResultString = '你好少时间去健身卡';

    // final listen = XfSpeechListener(onSpeakBegin: () {
    //   print('开始播放');
    // },
    // onSpeakProgress: () {
    //   print('播放完成');
    // });

    XfSpeechPlugin.instance.startSpeaking(
        string: iflyResultString,
        listener: XfSpeechListener(onSpeakBegin: () {
          print('开始播放');
          Future.delayed(Duration(seconds: 1), () async {
            bool isSpeaking = await XfSpeechPlugin.instance.isSpeaking();
            print(isSpeaking);
          });
        }, onSpeakProgress: (int i, int i1, int i2) {
          print('播放进度 $i $i1 $i2');
        }));

    /*
    final listen = XfSpeechListener(onVolumeChanged: (volume) {
      print('$volume');
    }, onResults: (String result, isLast) {
      if (result.length > 0) {
        setState(() {
          iflyResultString += result;
          XfSpeechPlugin.instance.startSpeaking(string: iflyResultString);
        });
      }
    }, onCompleted: (Map<dynamic, dynamic> errInfo, String filePath) {
      setState(() {});
    });
    XfSpeechPlugin.instance.startListening(listener: listen);
    */
  }

  onTapUp() {
    print("tap up");
    XfSpeechPlugin.instance.stopListening();
  }
}
