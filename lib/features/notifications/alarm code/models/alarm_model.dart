class AlarmModel {
  String? label;
  String dateTime;
  String? alarmDate;
  bool isActive;
  String? repeat;
  int id;
  int? milliseconds;
  String? ringtone;
  int? snoozeDuration;

  AlarmModel({
    this.label,
    required this.dateTime,
    this.alarmDate,
    this.isActive = true,
    this.repeat,
    required this.id,
    this.milliseconds,
    this.ringtone,
    this.snoozeDuration,
  });

  factory AlarmModel.fromJson(Map<String, dynamic> json) => AlarmModel(
        label: json["label"],
        dateTime: json["dateTime"],
        alarmDate: json["alarmDate"],
        isActive: json["isActive"] ?? true,
        repeat: json["repeat"],
        id: json["id"],
        milliseconds: json["milliseconds"],
        ringtone: json["ringtone"],
        snoozeDuration: json["snoozeDuration"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "dateTime": dateTime,
        "alarmDate": alarmDate,
        "isActive": isActive,
        "repeat": repeat,
        "id": id,
        "milliseconds": milliseconds,
        "ringtone": ringtone,
        "snoozeDuration": snoozeDuration,
      };
}
