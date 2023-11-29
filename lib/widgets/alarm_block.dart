import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class AlarmBlock extends StatelessWidget {
  const AlarmBlock({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.15;

    return Container(
      height: containerHeight,
      child: Row(children: [
        Text('오전\n오후 '),
        Text('시간'),
        Expanded(child: Container(),),
        Text('요일'),//전부면 매일로, 부분이면 부분만
        OnOffSwitch(),
      ]),
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


