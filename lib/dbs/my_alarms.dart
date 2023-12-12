class MyAlarm {
  final int id;
  final String alarmName;
  final String alarmTime;
  final String alarmDay;
  final int usingAlarmSound;

  MyAlarm(
    {
      required this.id,
      required this.alarmName,
      required this.alarmTime,
      required this.alarmDay,
      required this.usingAlarmSound
    }
  );

  Map<String, dynamic> toMap() {
    return {'alarmName':alarmName, 'alarmTime':alarmTime, 'alarmDay':alarmDay, 'usingAlarmSound':usingAlarmSound};
  }
  
  Map<String, dynamic> toUpdateMap() {
    return {'alarmName':alarmName, 'alarmTime':alarmTime, 'alarmDay':alarmDay, 'usingAlarmSound':usingAlarmSound};
  }
  
}