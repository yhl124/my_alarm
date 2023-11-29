import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('두 번째 화면'),
      ),
      body: Center(
        child: Text('이것은 두 번째 화면입니다.'),
      ),
    );
  }
}
