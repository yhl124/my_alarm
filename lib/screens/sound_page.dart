import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

//오디오 재생, 기본 벨소리 가져올때 필요
//import 'package:audioplayers/audioplayers.dart';
//import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class SoundPage extends StatefulWidget {
  final bool enabledCheck;
  
  SoundPage(this.enabledCheck);

  @override
  State<SoundPage> createState() => _SoundPageState();
}

enum SoundOptions {inclusion, exception}

class _SoundPageState extends State<SoundPage> {
  //오디오 플레이어와 벨소리 저장용 리스트
  //final _audioPlayer = AudioPlayer();
  //List<Ringtone> ringtones = [];

  bool _enabeldCheck = true;
  bool isSoundPlaying = false;
  
  
  @override
  void initState(){
    super.initState();
    _enabeldCheck = widget.enabledCheck;
    
    //getRingtones();
  }

  /*
  //이 메소드를 사용하면 리스트 반환됨
  Future<void> getRingtones() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      final temp = await FlutterSystemRingtones.getRingtoneSounds();
      setState(() {
        ringtones = temp;
      });
    } on PlatformException {
      debugPrint('Failed to get platform version.');
    }
    if (!mounted) return;
  }
  //오디오 플레이용
  void _playRingtone(ringtonename) async {
    debugPrint(ringtonename.toString());
    if (!isSoundPlaying) {
      _audioPlayer.play(ringtonename);
      setState(() {
        isSoundPlaying = true;
      });
    }
  }
  */

  @override
  Widget build(BuildContext context) {

  return WillPopScope(
    onWillPop: () async {
      Navigator.pop(context, _enabeldCheck);
      return false;
    },
    child: Scaffold(
        appBar: CupertinoNavigationBar(middle: Text('알람음')),
        body: Center(
          child: Column(
            children:[
              Container(//공휴일 알람설정
                height: MediaQuery.of(context).size.height * 0.08,
                padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
                child: ListTile(//divider 혹은 dividetiles 활용
                  title: Text(_enabeldCheck ? '사용 중' : '사용 안함', style: TextStyle(fontSize: 23)),
                  trailing: CupertinoSwitch(
                    value: _enabeldCheck, 
                    onChanged:(value){
                      setState(() {
                        _enabeldCheck = value;
                      });
                    }
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CupertinoButton.filled(
                                onPressed: _enabeldCheck ? () {
                                  if(!isSoundPlaying)
                                  {
                                    FlutterRingtonePlayer.playRingtone(looping: false);
                                    setState(() {
                                      isSoundPlaying = true;
                                    });
                                  }
                                }:null,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('playAlarm'),
                              ),
                              CupertinoButton.filled(
                                onPressed: _enabeldCheck ? () {
                                  if(isSoundPlaying)
                                  {
                                    setState(() {
                                      FlutterRingtonePlayer.stop();
                                      isSoundPlaying = false;
                                    });
                                  }
                                }:null,
                                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                child: Text('stopAlarm'),
                              ),
                            ],
                          )
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        )
      ),
  );

  }
  

  @override
  void dispose(){
    super.dispose();
    FlutterRingtonePlayer.stop();
  }
}


/*
@override
  Widget build(BuildContext context) {

  return Scaffold(
      appBar: CupertinoNavigationBar(middle: Text('알람음')),
      body: ListView.builder(
        itemCount: ringtones.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(ringtones[index].title),
            subtitle: Text(ringtones[index].uri),
            onTap: () {
              _playRingtone(Uri.parse(ringtones[index].uri).toString());
            },
          );
        }
      )
    );
  }
}

*/
