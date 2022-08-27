import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/application_user.dart';

class BookingModel {
  String? bookingId;
  late String massageShopId;
  late String startingDate;
  late String endingDate;
  late String noOfClients;
  late final String phoneNumber;

  /// 0 for pending , 1 for accepted,2 for completed,  and 3 for rejected
  late int status;
  late final ApplicationUser bookedUser;
  late final DateTime createdAt;
  late String visitingTime;

  BookingModel(
      {required this.startingDate,
      this.bookingId,
      required this.massageShopId,
      required this.endingDate,
      required this.status,
      required this.noOfClients,
      required this.phoneNumber,
      required this.visitingTime,
      required this.bookedUser});

  Map<String, dynamic> toJson() {
    return {
      "user": bookedUser.toMap(),
      "massage_shop_id": massageShopId,
      "starting_date": startingDate,
      "ending_date": endingDate,
      "no_of_clients": noOfClients,
      'status': status,
      'phoneNumber': phoneNumber,
      'visitingTime': visitingTime,
      'created_at': FieldValue.serverTimestamp()
    };
  }

  String get getStatus {
    if (status == 0)
      return translator.pending;
    else if (status == 1)
      return translator.reserved;
    else if (status == 2)
      return translator.done;
    else
      return translator.cancel;
  }

  BookingModel.fromJson(Map<String, dynamic> map, String id) {
    startingDate = map['starting_date'].toString().replaceAll('/', '.');
    endingDate = map['ending_date'].toString().replaceAll('/', '.');
    massageShopId = map['massage_shop_id'];
    bookedUser = ApplicationUser.fromMap(map['user']);
    bookingId = id;
    noOfClients = map['no_of_clients'];
    status = map['status'] ?? 0;
    createdAt = map['created_at'] == null
        ? DateTime.now()
        : (map['created_at'] as Timestamp).toDate();
    phoneNumber = map['phoneNumber'] ?? '';
    visitingTime = map['visitingTime'] ?? '';
    try {
      visitingTime = visitingTime.split(':').sublist(0, 2).toList().join(':');
    } catch (_) {}
  }
}
