import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingBlock extends StatelessWidget {
  //매개변수로 받아올 listtile용 변수들 : 타이틀, 서브타이틀, 넘어갈페이지
  final String maintext;
  final String subtext;
  final Widget nextpage;

  const SettingBlock(
    {
      Key? key,
      this.maintext = '정할 상태값(공휴일, 소리 등)',
      this.subtext = '자세한 내용',
      required this.nextpage,
    }
  ):super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.10;
    
    return Container(
      height: containerHeight,
      child: ListTile(
        title: Text(maintext),
        subtitle: Text(subtext),
        onTap: () {
          Navigator.push(
            context,//여기서 연 빈 페이지에서 뒤로가면 메인으로가버림
            MaterialPageRoute(builder: (context) => nextpage),
          );
        },
        trailing: OnOffSwitch(),
      ),
    );
  }
}

class OnOffSwitch extends StatefulWidget {
  const OnOffSwitch({
    super.key,
  });

  @override
  State<OnOffSwitch> createState() => _OnOffSwitchState();
}

class _OnOffSwitchState extends State<OnOffSwitch> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: switchValue, 
      onChanged: (value){
        setState(() {
          switchValue = value;
        });
      });
  }
}


