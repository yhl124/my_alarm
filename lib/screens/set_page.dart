import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/widgets/setting_block.dart';
import 'empty_page.dart';


class SetPage extends StatelessWidget {
  const SetPage({super.key});

  @override
  Widget build(BuildContext context) {

  return Scaffold(
      body: SetHomePage()
    );
  }
}

class SetHomePage extends StatefulWidget {
  const SetHomePage({
    super.key,
  });

  @override
  State<SetHomePage> createState() => _SetHomePageState();
}
enum Days {sun,mon,tue,wed,tur,fri,sat}
const List<(Days, String)> dayOfTheWeek = <(Days, String)>[
  (Days.sun, '일'),
  (Days.mon, '월'),
  (Days.tue, '화'),
  (Days.wed, '수'),
  (Days.tur, '목'),
  (Days.fri, '금'),
  (Days.sat, '토'),
];

class _SetHomePageState extends State<SetHomePage> {
  DateTime time = DateTime.now();
  //final List<bool> _toggleButtonsSelection = Days.values.map((Days e) => e != Days.sun).toList();
  final List<bool> _toggleButtonsSelection = [false, false, false, false, false, false, false];
  //나중에는 Days의 개수나 dayOfTheWeek의 개수 가져와서 그 크기의 false리스트 만들면 될듯

  @override
  Widget build(BuildContext context) {
    return WillPopScope(//뒤로가기 핸들링
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(20.0),
          child: AppBar( 
            backgroundColor: Colors.transparent,
            elevation: 0,
          )
        ),
        body: ListView(
          padding: EdgeInsets.all(3.0),
          children: [
            Container(//시간지정
              //color: Colors.black,
              height: MediaQuery.of(context).size.height * 0.30,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: time,
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() => time = newTime);
                },
              ),
            ),
            Container(//선택된 날 표시텍스트 & 달력선택
              //color: Colors.black,
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              height: MediaQuery.of(context).size.height * 0.07,
              child: Row(
                children: [
                  Text('선택된 날짜나 요일'),
                  Expanded(child: Container(),),
                  CupertinoButton(//날짜 선택 버튼
                    padding: EdgeInsets.all(5),
                    onPressed: () {
                      //나중에구현
                    },
                    child: Icon(CupertinoIcons.calendar, color: Color.fromARGB(255, 46, 42, 42)),
                  )
                ],
              )
            ),
            Container(//요일선택
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              height: MediaQuery.of(context).size.height * 0.05,
              child: ToggleButtons(
                isSelected: _toggleButtonsSelection,
                onPressed: (int index) {
                  setState(() {
                  _toggleButtonsSelection[index] = !_toggleButtonsSelection[index];
                  });
                },
                children: 
                  //아마도 리스트.map으로 <Days, String>으로 이루어진 리스트에서 2번째 값을 text로 가져와 리스트로 변환하는듯
                  dayOfTheWeek.map(((Days, String) day) => Text(day.$2)).toList(),
              )
            ),
            SettingBlock(maintext: '공휴일에는 끄기', subtext: '설정된 값 표시', nextpage: EmptyPage()),
          ],
        ),
      ),
    );
  }

  
  Future<bool> _onWillPop(BuildContext context) async {
    // 뒤로가기 버튼을 눌렀을 때 확인/취소 다이얼로그 표시
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('경고'),
          content: Text('정말로 나가시겠습니까?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // 확인 버튼
              },
              child: Text('확인'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // 취소 버튼
              },
              child: Text('취소'),
            ),
          ],
        );
      },
    );
    return confirm ?? false;
  }
}