import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class HolidayPage extends StatefulWidget {
  const HolidayPage({super.key});

  @override
  State<HolidayPage> createState() => _HolidayPageState();
}

enum HolidayOptions {inclusion, exception}

class _HolidayPageState extends State<HolidayPage> {
  bool _enabeldCheck = true;
  HolidayOptions _option = HolidayOptions.exception;

  @override
  Widget build(BuildContext context) {

  return Scaffold(
      appBar: CupertinoNavigationBar(middle: Text('공휴일에는 끄기')),
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
                  //요일 선택을 했을때만 공휴일 설정 가능하도록
                  onChanged:(value){
                    setState(() {
                      _enabeldCheck = value;
                    });
                  }
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(child: Text('공휴일에는 반복 설정된 알람이 울리지 않도록 자동으로 해제합니다.'),),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Container(
              child: Column(
                children: [
                  Card(
                    child: Column(
                      children: [
                        RadioListTile(
                          title: Text('대체 공휴일 및 임시 공휴일 포함'),
                          value: HolidayOptions.inclusion,
                          groupValue: _option,
                          onChanged: _enabeldCheck ? (HolidayOptions? value) {
                            setState(() {
                              _option = value as HolidayOptions;
                            });
                          }:null,
                        ),
                        Divider(),
                        RadioListTile(
                          title: Text('대체 공휴일 및 임시공휴일 제외'),
                          value: HolidayOptions.exception,
                          groupValue: _option,
                          onChanged: _enabeldCheck ? (HolidayOptions? value) {
                            setState(() {
                              _option = value as HolidayOptions;
                            });
                          } : null,
                        ),
                      ],
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