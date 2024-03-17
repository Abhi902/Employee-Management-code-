import 'package:image_picker/image_picker.dart';

class CommonFormModel {
  String? uid;
  String? lastUpdatedPerson;
  String name;
  XFile? photo;
  String category;
  String reference;
  String rate;
  String attendance;
  String amount;
  String advance;
  String kharcha;
  String autoRent;
  String? photoLocation;
  DateTime? createdAt;
  DateTime? lastUpdateAdvance;
  DateTime? lastUpdateKharcha;
  DateTime? lastUpdateAutoRent;
  DateTime? lastUpdateRate;
  DateTime? lastUpdateAttendance;
  List<Map<String, List<String>>>? manager;

  CommonFormModel({
    required this.name,
    this.photo,
    required this.category,
    required this.reference,
    required this.rate,
    required this.attendance,
    required this.amount,
    required this.advance,
    required this.kharcha,
    required this.autoRent,
    this.createdAt,
    this.lastUpdateAdvance,
    this.lastUpdateKharcha,
    this.lastUpdateAutoRent,
    this.lastUpdateRate,
    this.lastUpdateAttendance,
    this.uid,
    this.lastUpdatedPerson,
    this.photoLocation,
    this.manager,
  });

  CommonFormModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        photoLocation = json['photo_location'] ?? "",
        photo = json['photo'] != null ? XFile(json['photo'] as String) : null,
        category = json['category'] ?? '',
        lastUpdatedPerson = json['lastUpdatedPerson'] ?? '',
        reference = json['reference'] ?? '',
        rate = json['rate'] ?? '',
        attendance = json['attendance'] ?? '',
        amount = json['amount'] ?? '',
        advance = json['advance'] ?? '',
        kharcha = json['kharcha'] ?? '',
        autoRent = json['autoRent'] ?? '',
        createdAt = (json['createdAt'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
            : null,
        lastUpdateAdvance = (json['lastUpdateAdvance'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                json['lastUpdateAdvance'] as int)
            : null,
        lastUpdateAttendance = (json['lastUpdateAttendance'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                json['lastUpdateAttendance'] as int)
            : null,
        lastUpdateKharcha = (json['lastUpdateKharcha'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                json['lastUpdateKharcha'] as int)
            : null,
        lastUpdateAutoRent = (json['lastUpdateAutoRent'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(
                json['lastUpdateAutoRent'] as int)
            : null,
        lastUpdateRate = (json['lastUpdateRate'] != null)
            ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdateRate'] as int)
            : null,
        uid = json['uid'] ?? '',
        manager = json['manager'] != null
            ? List<Map<String, List<String>>>.from(json['manager'].map(
                (managerItem) => Map<String, List<String>>.from(managerItem.map(
                    (key, value) => MapEntry(key, List<String>.from(value))))))
            : null;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'photo': photo?.path,
      'category': category,
      'reference': reference,
      'rate': rate,
      'attendance': attendance,
      'amount': amount,
      'advance': advance,
      'kharcha': kharcha,
      'photo_location': photoLocation,
      'autoRent': autoRent,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastUpdateAdvance': lastUpdateAdvance?.millisecondsSinceEpoch,
      'lastUpdateKharcha': lastUpdateKharcha?.millisecondsSinceEpoch,
      'lastUpdateAutoRent': lastUpdateAutoRent?.millisecondsSinceEpoch,
      'lastUpdateRate': lastUpdateRate?.millisecondsSinceEpoch,
      'uid': uid,
      "lastUpdatedPerson": lastUpdatedPerson,
      'lastUpdateAttendance': lastUpdateAttendance?.microsecondsSinceEpoch,
      'manager': manager
          ?.map((item) => item.map(
                (key, value) => MapEntry(key, value),
              ))
          .toList(),
    };
  }
}
