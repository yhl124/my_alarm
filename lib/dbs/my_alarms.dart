class MyAlarm {
  final int id;
  final String alarmName;
  final String alarmTime;
  final int usingAlarmSound;

  MyAlarm(
    {
      required this.id,
      required this.alarmName,
      required this.alarmTime,
      required this.usingAlarmSound
    }
  );

  Map<String, dynamic> toMap() {
    return {'alarmName':alarmName, 'alarmTime':alarmTime, 'usingAlarmSound':usingAlarmSound};
  }
  
  Map<String, dynamic> toUpdateMap() {
    return {'alarmName':alarmName, 'alarmTime':alarmTime, 'usingAlarmSound':usingAlarmSound};
  }
  
}