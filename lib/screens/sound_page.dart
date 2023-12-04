import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

class SoundPage extends StatefulWidget {
  const SoundPage({super.key});

  @override
  State<SoundPage> createState() => _SoundPageState();
}

enum SoundOptions {inclusion, exception}

class _SoundPageState extends State<SoundPage> {
  bool _enabeldCheck = true;
  bool isSoundPlaying = false;
  
  List<Ringtone> ringtones = [];

  @override
  void initState(){
    super.initState();
    getRingtones();
  }

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
          );
        }
      )
    );
  }
}

/*
  @override
  Widget build(BuildContext context) {

  return Scaffold(
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
                        ListView.builder(
                          itemCount: ringtones.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(ringtones[index].title),
                              subtitle: Text(ringtones[index].uri),
                            );
                          }
                        ),


                        /*
                        ElevatedButton(
                          child: const Text('playAlarm'),
                          onPressed: () {
                            if(!isSoundPlaying)
                            {
                              FlutterRingtonePlayer.playRingtone(looping: false);
                              setState(() {
                                isSoundPlaying = true;
                              });
                            }
                          },
                        )*/
                      ]
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      )
    );
  }
}
*/