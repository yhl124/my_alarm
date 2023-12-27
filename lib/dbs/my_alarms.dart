class MyAlarm {
  // final int notiId;
  final String alarmId;
  final int useDate;
  final String alarmDate;
  final String alarmTime;
  final String alarmName;
  final int useHoliday;
  final int holidayOp;
  final int useSound;
  final String soundName;
  final int useVibe;
  final String vibeOp;
  final int useRepeat;
  final int repeatOp;

  MyAlarm(
    {
      //required this.notiId,
      required this.alarmId,
      required this.useDate,
      required this.alarmDate,
      required this.alarmTime,
      required this.alarmName,
      required this.useHoliday,
      required this.holidayOp,
      required this.useSound,
      required this.soundName,
      required this.useVibe,
      required this.vibeOp,
      required this.useRepeat,
      required this.repeatOp
    }
  );

  Map<String, dynamic> toMap() {
    return {
      //'notiId' : notiId,
      'alarmId' : alarmId,
      'useDate' : useDate,
      'alarmDate' : alarmDate,
      'alarmTime' : alarmTime,
      'alarmName' : alarmName,
      'useHoliday' : useHoliday,
      'holidayOp' : holidayOp,
      'useSound' : useSound,
      'soundName' : soundName,
      'useVibe' : useVibe,
      'vibeOp' : vibeOp,
      'useRepeat' : useRepeat,
      'repeatOp' : repeatOp
    };
  }

}