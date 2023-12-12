import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '/dbs/my_alarms.dart';
import '/dbs/dbConfig.dart';
import '/widgets/notification.dart';

class AlarmBlock extends StatefulWidget {
  final int alarmId;

  const AlarmBlock({
    Key? key,
    required this.alarmId
  }) : super(key: key);

  @override
  State<AlarmBlock> createState() => _AlarmBlockState();
}

class _AlarmBlockState extends State<AlarmBlock> {

  //현재 선택한 알람의 정보
  MyAlarm? _thisAlarm;
  bool switchValue = true;

  @override
  void initState() {
    super.initState();
    _getAlarmInfo();
    //FlutterLocalNotification.init();
    //print(_thisAlarm.toString());
  }

  Future<void> _getAlarmInfo() async {
    final MyAlarm myalarmInfo = await DatabaseHelper.instance.selectAlarm(widget.alarmId);

    setState(() {
      _thisAlarm = myalarmInfo;
      //print(_thisAlarm.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Row(children: [
          if (_thisAlarm != null)//알람 울리는 시간 표시
            Text(_thisAlarm!.alarmTime.split(' ')[1].toString()),
          Expanded(child: Container(),),
          if (_thisAlarm != null)//알람 울리는 날 표시
            Text(_thisAlarm!.alarmDay),
          CupertinoSwitch(//알람 온오프 스위치
            value: switchValue, 
            onChanged: (value) {
              setState(() {
                switchValue = value;
                if(value == true){
                  //알람 스위치 on이면 알람에 등록 또는 해제
                  if (_thisAlarm != null) FlutterLocalNotification.scheduledNotification(_thisAlarm!.id);
                }
                else if(value == false){
                  if (_thisAlarm != null) FlutterLocalNotification.cancelNotification(_thisAlarm!.id);
                }
              });
            }
          ),
        ]),
      ),
    );
  }
}



