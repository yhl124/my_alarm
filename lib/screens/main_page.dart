import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'set_page.dart';
import '/widgets/alarm_block.dart';


class MainPage extends StatelessWidget {
  const MainPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        //appBar: AppBar(),
        body: ListView(//나중에 .separeated추가, 스크롤바 안보임문제
          padding: EdgeInsets.all(3),
          children: [
            RemainingText(),//알람까지 얼마 남았는지 표시하는 부분
            AddOptionButtons(),//알람추가, 옵션버튼부분
            BodyList(),//저장된 알람 표시부분
          ],
        )
      )
    );
  }
}

class RemainingText extends StatelessWidget {
  const RemainingText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('가장 시간이 적게남은 알람이 얼마 뒤에 울리는지 텍스트'),
        ],
      ),
    );
  }
}

class AddOptionButtons extends StatelessWidget {
  const AddOptionButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class BodyList extends StatelessWidget {
  const BodyList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: 
        [
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
          AlarmBlock(),
        ],
      )
    );
  }
}


