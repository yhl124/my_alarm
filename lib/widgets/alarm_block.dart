import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//import '/dbs/my_alarms.dart';
import '/dbs/dbConfig.dart';
import '/widgets/notification.dart';

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

  //현재 선택한 알람의 정보, 요일사용이면 여러개 아니면 한개
  List<Map<String, dynamic>>? _thisAlarm;
  bool switchValue = true;

  @override
  void initState() {
    super.initState();

    _getAlarmInfo().then((value) {
      DateTime alarmDate = DateTime.parse(_thisAlarm![0]['alarmDate']);
      DateTime alarmTime = DateTime.parse(_thisAlarm![0]['alarmTime']);

      int year1 = alarmDate.year;
      int month1 = alarmDate.month;
      int day1 = alarmDate.day;
      int hour1 = alarmTime.hour;
      int minute1 = alarmTime.minute;
      DateTime alarmDT = DateTime(year1, month1, day1, hour1, minute1);

      if(_thisAlarm != null && alarmDT.isAfter(DateTime.now()) && _thisAlarm![0]['useDate'] == 1){//날짜 알람
        FlutterLocalNotification.scheduledNotification(_thisAlarm![0]['notiId'], _thisAlarm![0]['alarmDate'], _thisAlarm![0]['alarmTime']);
      }
      else if(_thisAlarm != null && !alarmDT.isAfter(DateTime.now()) && _thisAlarm![0]['useDate'] == 1){//시간이 지난 날짜 알람
        switchValue = false;
      }
      else if(_thisAlarm != null && _thisAlarm![0]['useDate'] == 0){//요일 알람
        for(int i=0; i<_thisAlarm!.length; i++){
          FlutterLocalNotification.scheduleYearlyNotification(_thisAlarm![i]['notiId'], _thisAlarm![i]['alarmDate'], _thisAlarm![i]['alarmTime']);
        }
      }
    });
  }

  Future<void> _getAlarmInfo() async {
    final List<Map<String, dynamic>> myalarmInfo = await DatabaseHelper.instance.selectblockAlarms(widget.alarmId);

    setState(() {
      _thisAlarm = myalarmInfo;
      print(_thisAlarm.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.12,
        child: Row(children: [
          //알람 울리는 시간 표시
          if(_thisAlarm != null)
            Text(_thisAlarm![0]['alarmTime'].split(' ')[1].toString()),
          Expanded(child: Container(),),
          //알람 울리는 날 표시
          if(_thisAlarm != null)
            Text(_thisAlarm![0]['useDate'] == 0 
              ? '매주 ${_thisAlarm!.map((e) => DateTime.parse(e['alarmDate']).weekday)
                .map((f) => {7: '일', 1: '월',2: '화',3: '수',4: '목', 5: '금',6: '토'}[f]).toList().join(', ')}'
              : _thisAlarm![0]['alarmDate'].split(' ')[0].toString()),
          CupertinoSwitch(//알람 온오프 스위치
            value: switchValue, 
            onChanged: (value) {
              setState(() {
                switchValue = value;
                if(value == true){
                  //알람 스위치 상태에 따라 알람에 등록 또는 해제
                  for(int i=0; i<_thisAlarm!.length; i++)
                  {
                    if(_thisAlarm![0]['useDate'] == 0){//요일 알람 등록
                      FlutterLocalNotification.scheduleYearlyNotification(_thisAlarm![i]['notiID'], _thisAlarm![i]['alarmDate'], _thisAlarm![i]['alarmTime']);
                    }
                    else if(_thisAlarm![0]['useDate'] == 0){//날짜 알람 등록
                      FlutterLocalNotification.scheduledNotification(_thisAlarm![i]['notiID'], _thisAlarm![i]['alarmDate'], _thisAlarm![i]['alarmTime']);
                    }
                    
                  }
                }
                else if(value == false){
                  for(int i=0; i<_thisAlarm!.length ; i++){
                    FlutterLocalNotification.cancelNotification(_thisAlarm![i]['notiId']);
                  }
                }
              });
            }
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    for(int i=0; i<_thisAlarm!.length ; i++){
      FlutterLocalNotification.cancelNotification(_thisAlarm![i]['notiId']);
    }
    super.dispose();
  }
}



