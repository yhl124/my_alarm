import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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

  List<DateTime?> _singleDatePickerValueWithDefaultValue = [DateTime.now(),];//달력 기본 선택날짜
  DateTime _selectedDate = DateTime.now();//달력에서 선택한 날짜

  //final List<bool> _toggleButtonsSelection = Days.values.map((Days e) => e != Days.sun).toList();
  final List<bool> _toggleButtonsSelection = [false, false, false, false, false, false, false];
  //나중에는 Days의 개수나 dayOfTheWeek의 개수 가져와서 그 크기의 false리스트 만들면 될듯
  TextEditingController _textController = TextEditingController();

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
                initialDateTime: time,//이걸 수정해서 am pm순서 변경 가능할지도?
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() => time = newTime);
                },
              ),
            ),
            Container(//선택된 날 표시텍스트 & 달력선택
              //color: Colors.black,
              padding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                children: [
                  Text(_selectedDate.toString()),
                  //Text('선택 날짜나 요일'),
                  Expanded(child: Container(),),
                  CupertinoButton(//날짜 선택 버튼
                    padding: EdgeInsets.all(5),
                    onPressed: () {
                      showCalendarDatePicker2Dialog(//달력에서 날짜선택
                        context: context,
                        config: CalendarDatePicker2WithActionButtonsConfig(
                          firstDate: DateTime.now(), 
                          lastDate: DateTime(2100),
                        ),
                        dialogSize: Size(325, 400),
                        borderRadius: BorderRadius.circular(15),
                        value: _singleDatePickerValueWithDefaultValue,
                      ).then((selectedDate) {
                        //debugPrint(selectedDate.toString());
                        if(selectedDate != null){//취소하면 null ok면 notnull
                          setState(() {
                            _selectedDate = selectedDate[0] as DateTime;
                          });
                        }
                      });
                    },
                    child: Icon(CupertinoIcons.calendar, color: Color.fromARGB(255, 46, 42, 42)),
                  )
                ],
              )
            ),
            Container(//요일선택
              padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
              height: MediaQuery.of(context).size.height * 0.05,
              child: Center(
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
                ),
              )
            ),
            //알람이름 설정
            Container(
              padding: EdgeInsets.fromLTRB(30.0, 27.0, 30.0, 13.0),
              height: MediaQuery.of(context).size.height * 0.10,
              child: Center(
                child: CupertinoTextField(
                  placeholder: '알람 이름',
                  controller: _textController,
                ),
              ),
            ),
            SettingBlock(maintext: '알람음', subtext: '설정된 값 표시', nextpage: EmptyPage()),
            Container(height: 1.0, padding: EdgeInsets.fromLTRB(30, 0, 30, 0), child: Container(color: const Color.fromARGB(255, 199, 193, 193),)),
            SettingBlock(maintext: '진동', subtext: '설정된 값 표시', nextpage: EmptyPage()),
            Container(height: 1.0, padding: EdgeInsets.fromLTRB(30, 0, 30, 0), child: Container(color: const Color.fromARGB(255, 199, 193, 193),)),
            SettingBlock(maintext: '다시 울림', subtext: '설정된 값 표시', nextpage: EmptyPage()),
          ],
        ),
        //하단 취소 저장 //키보드에 바텀바가 안올라오게 설정 필요
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('취소', style: TextStyle(fontSize: 20),)
              ),
              CupertinoButton(
                onPressed: () {},
                child: Text('저장', style: TextStyle(fontSize: 20),)
              ),
            ],
          )
        ),
      ),
    );
  }
  
  Future<bool> _onWillPop(BuildContext context) async {
    // 뒤로가기 버튼을 눌렀을 때 확인/취소 다이얼로그 표시
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AnimatedAlign(
          alignment: Alignment.bottomCenter,
          duration: Duration(seconds: 1),
          //curve : Curves.fastOutSlowIn,
          child: Container(
            height: 300,
            width: double.infinity,
            color: Colors.transparent,
            child: CupertinoAlertDialog(
              title: Text('알림'),
              content : Text('저장하지 않고 나가시겠습니까?', style: TextStyle(fontSize: 15)),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('확인'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('취소'),
                )
              ],
            ),
          ),
          
        
        );
      },
    );

    return confirm ?? false;
  }
}