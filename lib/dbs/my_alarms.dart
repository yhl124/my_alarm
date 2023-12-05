class MyAlarm {
  final int id;
  final String alarmName;
  final String alarmTime;
  final String usingAlarmSound;

  MyAlarm(
    {
      required this.id,
      required this.alarmName,
      required this.alarmTime,
      required this.usingAlarmSound
    }
  );

  Map<String, dynamic> toMap() {
    return {'id': id, 'alarmName':alarmName, 'alarmTime':alarmTime, 'usingAlarmSound':usingAlarmSound};
  }
}