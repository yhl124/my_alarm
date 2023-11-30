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

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.08;
    
    return Container(
      height: containerHeight,
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
      child: Center(
        child: ListTile(//divider 혹은 dividetiles 활용
          title: Text(maintext),
          subtitle: Text(subtext),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => nextpage),
            );
          },
          trailing: OnOffSwitch(),
        ),
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


