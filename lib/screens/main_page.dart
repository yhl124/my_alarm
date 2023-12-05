import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
  final DataBaseService _dataBaseService = DataBaseService();

  @override
  void initState() {
    super.initState();
    _dataBaseService.selectAlarms().then((alarms) {
      _myalarms = alarms;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: PreferredSize(
            preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.4),
            child: Column(
              children: [
                Container(//알람까지 얼마 남았는지 표시하는 부분
                  height: 50.0, 
                  child:
                    Text('가장 시간이 적게남은 알람이 얼마 뒤에 울리는지 텍스트'),
                ),
                Container(//알람추가, 옵션버튼부분
                height: 30.0,
                //color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(//알람 추가 버튼
                      padding: EdgeInsets.all(5),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SetPage()),
                        );
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
      ),
      body: Column(
        children:[
          Expanded(//저장된 알람 표시부분
            child: ListView.builder(
              itemCount: _myalarms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_myalarms[index].alarmName),
                );
              },
            )
          ),
        ]
      ) 
    );
  }

  /*
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appBar: AppBar(),
        body: ListView(//나중에 .separeated추가, 스크롤바 안보임문제
          padding: EdgeInsets.all(3),
          children: [
            Container(//알람까지 얼마 남았는지 표시하는 부분
              height: MediaQuery.of(context).size.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('가장 시간이 적게남은 알람이 얼마 뒤에 울리는지 텍스트'),
                ],
              ),
            ),
            Container(//알람추가, 옵션버튼부분
              height: 30.0,
              //color: Colors.green,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(//알람 추가 버튼
                    padding: EdgeInsets.all(5),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SetPage()),
                      );
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
                ]
              )
            ),
            Expanded(//저장된 알람 표시부분
              child: ListView.builder(
                itemCount: _myalarms.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_myalarms[index].alarmName),
                  );
                },
              )
            ),
          ],
        )
      )
    );
  }
  */
}
