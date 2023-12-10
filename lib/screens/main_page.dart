import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '/dbs/my_alarms.dart';
import '/dbs/dbConfig.dart';
import 'set_page.dart';
import '/widgets/alarm_block.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});
  
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<MyAlarm> _myalarms = [];
  //final DataBaseService _dataBaseService = DataBaseService();

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _refreshAlarmList();

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //onSelectNotification: onSelectNotification
    );
    
    //_initLocalNotification();
  }

  Future<void> _refreshAlarmList() async {
    final List<MyAlarm> myalarmList = await DatabaseHelper.instance.selectAlarms();

    setState(() {
      _myalarms = myalarmList;
    });
  }
/*
   Future<void> _initLocalNotification() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    DarwinInitializationSettings initSettingsIOS =
        const DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );
    await _localNotification.initialize(
      initSettings,
    );
  }

*/
  Future<void> scheduleNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
        0, 
        'scheduled title', 
        'scheduled body', 
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), 
        NotificationDetails(android: androidPlatformChannelSpecifics), 
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> showPushAlarm() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
    );

    await flutterLocalNotificationsPlugin.show(
    0, 
    '로컬 푸시 알림', 
    '로컬 푸시 알림 테스트',
    NotificationDetails(android: androidPlatformChannelSpecifics), 
    payload: 'deepLink');
  }
 /*
  NotificationDetails _details = const NotificationDetails(
        android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  tz.TZDateTime _timeZoneSetting({
      required int hour,
      required int minute,
    }) {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
      tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduledDate =
          tz.TZDateTime(tz.local, _now.year, _now.month, _now.day, hour, minute);

      return scheduledDate;
    }

  Future<void> selectedDatePushAlarm() async {
    FlutterLocalNotificationsPlugin _localNotification =
        FlutterLocalNotificationsPlugin();

    await _localNotification.zonedSchedule(
        1,
        '로컬 푸시 알림 2',
        '특정 날짜 / 시간대 전송 알림',
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), 
        _details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.27),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 50,),
            Container(//알람까지 얼마 남았는지 표시하는 부분
              //color: Colors.yellow,
              alignment: Alignment.center,
              height: 50.0, 
              child:
                Text('가장 시간이 적게남은 알람이 얼마 뒤에 울리는지 텍스트'),
            ),
            Container(//알람추가, 옵션버튼부분
              height: 50.0,
              //color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      scheduleNotification();
                    },
                    child: Text('Schedule Notification'),
                  ),
                  CupertinoButton(//알람 추가 버튼
                    padding: EdgeInsets.all(5),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetPage(includeId:false, alarmId: '',)),
                      ).then((value) {
                        if(value != null && value as bool){
                          _refreshAlarmList();
                        }
                      });
                    },
                    child: Icon(CupertinoIcons.add, color: Color.fromARGB(255, 104, 93, 93)),
                  ),
                CupertinoButton(//설정 등 목록버튼
                  padding: EdgeInsets.all(5),
                  onPressed: () {
                    //나중에
                  },
                  child: Icon(CupertinoIcons.bars, color: const Color.fromARGB(255, 104, 93, 93)),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
      body: Column(
        children:[
          Expanded(//저장된 알람 표시부분
            child: ListView.builder(
              itemCount: _myalarms.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: ValueKey<MyAlarm>(_myalarms[index]),
                  background: Container(
                    color: Color.fromARGB(255, 240, 62, 49),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.0),
                    child: Icon(Icons.delete, color: Colors.white,),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      DatabaseHelper.instance.deleteAlarm(_myalarms[index].id);
                      _myalarms.removeAt(index);
                      //_refreshAlarmList();
                    });
                  },
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetPage(includeId: true, alarmId: _myalarms[index].id)),
                      ).then((value) {
                        if(value != null && value as bool){
                          _refreshAlarmList();
                        }
                      });
                    },
                    child: AlarmBlock(alarmId: _myalarms[index].id)
                  ),
                );
              },
            )
          ),
        ]
      ) 
    );
  }
}