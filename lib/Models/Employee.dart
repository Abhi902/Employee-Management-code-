import 'package:image_picker/image_picker.dart';

class CommonFormModel {
  String? uid;
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
  DateTime? createdAt;
  DateTime? lastUpdateAdvance;
  DateTime? lastUpdateKharcha;
  DateTime? lastUpdateAutoRent;
  DateTime? lastUpdateRate;

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
    this.uid,
  });

  CommonFormModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        photo = json['photo'] != null ? XFile(json['photo'] as String) : null,
        category = json['category'] ?? '',
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
        uid = json['uid'] ?? '';

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
      'autoRent': autoRent,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'lastUpdateAdvance': lastUpdateAdvance?.millisecondsSinceEpoch,
      'lastUpdateKharcha': lastUpdateKharcha?.millisecondsSinceEpoch,
      'lastUpdateAutoRent': lastUpdateAutoRent?.millisecondsSinceEpoch,
      'lastUpdateRate': lastUpdateRate?.millisecondsSinceEpoch,
      'uid': uid,
    };
  }
}
