import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Shop {
  late final String name;
  late final List<String> images;
  late final String id;
  late final num rating;
  late final double percentageDiscount;
  late final String address;
  late final bool isActive;
  String? userId;
  String? phoneNumber;
  LatLng? position;
  Placemark? placemark;
  late bool allowPush;
  late bool allowChat;
  late int maximumNotifications;
  DateTime? packageExpiryDate;
  String? openAt;
  String? closeAt;
  late int totalReviews;
  String? virtualNumber;
  String? recomendedBy;
  String? sellPrice;
  String? deposit;
  String? monthlyRent;
  String? equiptmentFee;
  String? facility;
  String? rentalPrice;
  late bool isSell;
  late bool isLease;
  late String purpose;
  int? averageMonthlyVisitor;
  late int totalvisits;
  String? shopDesciption;
  String? saleLeaseDescription;
  late num notificationKmRange;
  String? bankName;
  String? bankAccountNumber;
  String? bankAccountHolderName;
  String get addressName => this.placemark?.street ?? this.address;
  String? bookingId;

  Shop({
    required this.name,
    required this.images,
    required this.rating,
    required this.address,
    required this.position,
    required this.placemark,
    required this.percentageDiscount,
    required this.isSell,
    this.openAt,
    this.closeAt,
    this.isActive = true,
    this.allowChat = false,
    this.allowPush = false,
    this.userId,
    this.totalReviews = 0,
    this.recomendedBy,
    required this.phoneNumber,
    required this.isLease,
    required this.purpose,
    this.averageMonthlyVisitor,
    this.notificationKmRange = 5,
    this.shopDesciption,
    this.saleLeaseDescription,
    this.sellPrice,
    this.deposit,
    this.equiptmentFee,
    this.monthlyRent,
    this.facility,
    this.rentalPrice,
    this.bankAccountHolderName,
    this.bankAccountNumber,
    this.bankName,
  });
  Shop.fromMap(Map<String, dynamic> map, String id) {
    this.name = map['name'];
    images = [];
    for (var i in map['images']) {
      images.add(i);
    }
    this.id = id;

    this.rating =
        num.parse(((map['rating'] ?? 0.0).toDouble()).toStringAsFixed(2));
    this.percentageDiscount = map['percentageDiscount'];
    this.userId = map['userId'];

    this.phoneNumber = map['phoneNumber'];
    this.address = map['address'] ?? '';
    this.isActive = map['isActive'] ?? true;
    this.allowPush = map['allowPush'] ?? false;
    this.allowChat = map['allowChat'] ?? false;
    this.maximumNotifications = map['maximumNotifications'] ?? 0;
    if (map['packageExpiryDate'] != null) {
      this.packageExpiryDate = DateTime.parse(map['packageExpiryDate']);
    }
    if (map['location'] != null) {
      position = LatLng.fromJson(map['location']);
    }
    openAt = map['openAt'];
    closeAt = map['closeAt'];
    totalReviews = map['totalReviews'] ?? 0;
    virtualNumber = map['virtualNumber'];
    recomendedBy = map['recomendedBy'];
    sellPrice = map['sellPrice'];
    deposit = map['deposit'];
    facility = map['facility'];
    rentalPrice = map['rentalPrice'];
    monthlyRent = map['monthlyRent'];
    isSell = map['isSell'] ?? false;
    isLease = map['isLease'] ?? false;
    purpose = map['purpose'] ?? 'Reservation';
    averageMonthlyVisitor = map['averageMonthlyVisitor'] ?? 0;
    totalvisits = map['totalvisits'] ?? 0;
    shopDesciption = map['shopDesciption'] ?? '';
    saleLeaseDescription = map['saleLeaseDescription'] ?? '';
    notificationKmRange = map['notificationKmRange'] ?? 5;
    equiptmentFee = map['equiptmentFee'];
    placemark =
        map['placemark'] is Map ? Placemark.fromMap(map['placemark']) : null;
    bankAccountHolderName = map['bankAccountHolderName'];
    bankAccountNumber = map['bankAccountNumber'];
    bankName = map['bankName'];
  }
  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'images': this.images,
      'rating': this.rating,
      'isSell': this.isSell,
      'percentageDiscount': this.percentageDiscount,
      'userId': this.userId,
      'address': this.address,
      'isActive': this.isActive,
      'placemark': this.placemark?.toJson(),
      'location': this.position?.toJson(),
      'allowChat': allowChat,
      'allowPush': allowPush,
      'phoneNumber': phoneNumber,
      'recomendedBy': recomendedBy,
      'sellPrice': sellPrice,
      'deposit': deposit,
      'equiptmentFee': equiptmentFee,
      'monthlyRent': monthlyRent,
      'facility': facility,
      'rentalPrice': rentalPrice,
      'isLease': isLease,
      'purpose': purpose,
      'shopDesciption': shopDesciption,
      'saleLeaseDescription': saleLeaseDescription,
      'averageMonthlyVisitor': averageMonthlyVisitor ?? 0,
      'notificationKmRange': notificationKmRange,
      'bankAccountHolderName': bankAccountHolderName,
      'bankAccountNumber': bankAccountNumber,
      'bankName': bankName,
    };
  }
}
