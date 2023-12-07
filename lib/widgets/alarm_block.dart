import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '/dbs/my_alarms.dart';
import '/dbs/dbConfig.dart';

class AlarmBlock extends StatefulWidget {
  final String alarmId;

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
  bool switchValue = false;

  @override
  void initState() {
    super.initState();
    _getAlarmInfo();
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
          if (_thisAlarm != null)
            Text(_thisAlarm!.alarmTime),
          Expanded(child: Container(),),
          Text('요일'),//전부면 매일로, 부분이면 부분만
          CupertinoSwitch(
            value: switchValue, 
            onChanged: (value) {
              setState(() {
                switchValue = value;
              });
            }
          ),
        ]),
      ),
    );
  }
}



