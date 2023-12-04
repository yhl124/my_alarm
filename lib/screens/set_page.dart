import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '/widgets/setting_block.dart';
import 'holiday_page.dart';
import 'sound_page.dart';
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

  //오전 6시 이전 체크용, 0~5.99 true/ 6~23.99 false
  bool _beforeSixAM = false;
  //오늘 오전 6시
  final DateTime sixAM = 
    DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 6, 0);
  //오늘 날짜
  final DateTime today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  //달력에서 선택을 했으면
  bool _selectedCal = false;
  //달력에서 오늘을 선택 했으면
  bool _selectedToday = false;
  //달력 기본 선택날짜 리스트
  List<DateTime?> _singleDatePickerValueWithDefaultValue = [];

  //알람 선택 시간
  TimeOfDay _selectedTime = TimeOfDay(hour: 6, minute: 0);
  //알람 선택 날짜
  DateTime _selectedDate = DateTime.now();

  //선택한 요일이 하나라도 있으면 true
  bool _selectedToggles = false;
  //요일 선택 리스트, 나중에는 Days의 개수나 dayOfTheWeek의 개수 가져와서 그 크기의 false리스트 만들면 될듯
  final List<bool> _toggleButtonsSelection = [false, false, false, false, false, false, false];
  //알람 울릴 날을 표시하는 텍스트를 위한 리스트
  List<String> _daysForDisplay = [];

  TextEditingController _textController = TextEditingController();

  //설정 스위치 체크용
  bool holidaySwitch = false;
  bool soundSwitch = false;

  @override
  void initState(){
    super.initState();

    //지금이 오전 6시이전인지 체크, 이전이면 true
    _beforeSixAM = DateTime.now().isBefore(sixAM) ? true : false;
    //오전6시 이후면 기본 선택날짜는 내일
    _selectedDate = _beforeSixAM? today: today.add(Duration(days: 1));
    _singleDatePickerValueWithDefaultValue = [_selectedDate,];
    _daysForDisplay.add(DateFormat('MM월 dd일 E요일').format(_selectedDate).toString());
  }

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
                initialDateTime: sixAM,
                use24hFormat: false,
                onDateTimeChanged: (DateTime newTime) {
                  setState(() { 
                    //debugPrint(newTime.toString());
                    if(_selectedCal == false && _selectedToggles == false){
                       _selectedDate = newTime.isAfter(DateTime.now()) ? newTime : newTime.add(Duration(days:1));
                       _daysForDisplay.clear();
                       _daysForDisplay.add(DateFormat('MM월 dd일 E요일').format(_selectedDate).toString());
                    }
                    else if(_selectedCal == true && _selectedToday == true && _selectedToggles == false){
                      _selectedDate = newTime.isAfter(DateTime.now()) ? newTime : newTime.add(Duration(days:1));
                      _daysForDisplay.clear();
                      _daysForDisplay.add(DateFormat('MM월 dd일 E요일').format(_selectedDate).toString());
                    }
                    _selectedTime = TimeOfDay.fromDateTime(newTime);
                  });
                },
              ),
            ),
            Container(//선택된 날 표시텍스트 & 달력선택
              //color: Colors.black,
              padding: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                children: [
                  Text(_daysForDisplay.toString(), style: TextStyle(fontSize: 15),),//선택한 날짜 or 요일 표시 텍스트
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
                        setState(() {
                          if(selectedDate != null){//취소하면 null ok면 notnull
                            //선택값이 리스트에 저장되는데 이 달력은 날짜 한개만 선택하기 때문에 리스트 첫번째값을 선택날짜로
                            _selectedDate = selectedDate[0] as DateTime;
                            //달력 선택을 했으면
                            _selectedCal = true;
                            //달력에서 오늘을 선택했으면 true 아니면 false
                            _selectedToday = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day).compareTo(today)==0
                              ? true : false;
                            //달력에서 선택하면 리스트를 비우고 그 날짜 추가
                            _daysForDisplay.clear();
                            _daysForDisplay.add(DateFormat('MM월 dd일 E요일').format(_selectedDate).toString());
                            //달력내 선택날짜 변경
                            _singleDatePickerValueWithDefaultValue.clear();
                            _singleDatePickerValueWithDefaultValue.add(_selectedDate);
                            //debugPrint(selectedDate.toString());
                          }
                        });
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
                      //debugPrint(_toggleButtonsSelection.toString());

                      //선택된 요일의 인덱스를 리스트에 저장
                      List<int> selectedIndexes = [];
                      for(int i=0; i<_toggleButtonsSelection.length; i++){
                        if(_toggleButtonsSelection[i]){
                          selectedIndexes.add(i);
                        }
                      }
                      //출력용 리스트에 요일 추가
                      _daysForDisplay.clear();
                      _daysForDisplay.add('매주 ');
                      _selectedToggles = true;
                      selectedIndexes.forEach((index) {
                        _daysForDisplay.add(dayOfTheWeek[index].$2);
                      },);
                      if(selectedIndexes.isEmpty){
                        _selectedToggles = false;
                        _daysForDisplay.clear();
                        _daysForDisplay.add(DateFormat('MM월 dd일 E요일').format(_selectedDate).toString());
                      }
                    });
                  },
                  children: 
                    dayOfTheWeek.map(((Days, String) day) => Text(day.$2)).toList(),
                ),
              )
            ),
            Container(height: 10.0, padding: EdgeInsets.fromLTRB(30, 0, 30, 0),),
            Container(//공휴일 알람설정
              height: MediaQuery.of(context).size.height * 0.08,
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Center(
                child: ListTile(//divider 혹은 dividetiles 활용
                  title: Text('공휴일에는 끄기'),
                  subtitle: Text('설정된 값 표시'),
                  //요일 선택을 했을때만 공휴일 설정 가능하도록
                  enabled : _selectedToggles,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HolidayPage()),
                    );
                  },
                  trailing: CupertinoSwitch(
                    value: holidaySwitch, 
                    //요일 선택을 했을때만 공휴일 설정 가능하도록
                    onChanged: _selectedToggles ? (value){
                      setState(() {
                        holidaySwitch = value;
                      });
                    }:null
                  ),
                ),
              ),
            ),

            //StatefulSettingBlock(maintext: '공휴일에는 끄기', subtext: '설정된 값 표시', nextpage: EmptyPage(), enableSetting: _holidaySetting,),
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
            Container(//알람음 설정
              height: MediaQuery.of(context).size.height * 0.08,
              padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Center(
                child: ListTile(
                  title: Text('알람음'),
                  subtitle: Text('설정된 값 표시'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SoundPage()),
                    );
                  },
                  trailing: CupertinoSwitch(
                    value: soundSwitch, 
                    onChanged: (value){
                      setState(() {
                        soundSwitch = value;
                      });
                    }
                  ),
                ),
              ),
            ),
            Divider(indent: 30.0, endIndent: 30.0,),
            SettingBlock(maintext: '진동', subtext: '설정된 값 표시', nextpage: EmptyPage()),
            Divider(indent: 30.0, endIndent: 30.0,),
            SettingBlock(maintext: '다시 울림', subtext: '설정된 값 표시', nextpage: EmptyPage()),
          ],
        ),
        //하단 취소 저장
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
              title: Text('알림\n'),
              content : Text('저장하지 않고 나가시겠습니까?\n', style: TextStyle(fontSize: 15)),
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