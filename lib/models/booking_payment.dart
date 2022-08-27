import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:massageapp/models/reservation_time_model.dart';

class BookingPayment {
  late final String reservationPersonName;
  late final String nameOfTheSender;
  late final String contact;
  late final String shopId;
  late final String bookingId;
  late final String userId;
  ReservationTimeModel? customTime;
  BookingPayment(
      {required this.reservationPersonName,
      required this.nameOfTheSender,
      required this.bookingId,
      required this.contact,
      required this.shopId,
      this.customTime,
      required this.userId});
  BookingPayment.fromMap(Map<String, dynamic> map) {
    reservationPersonName = map['reservationPersonName'];
    nameOfTheSender = map['nameOfTheSender'];
    contact = map['contact'];
    shopId = map['shopId'];
    bookingId = map['bookingId'];
    userId = map['userId'];
    customTime = map['customTime'] == null
        ? null
        : ReservationTimeModel.fromMap(map['customTime'], 'xxx');
  }

  Map<String, dynamic> toMap() {
    return {
      'reservationPersonName': this.reservationPersonName,
      'nameOfTheSender': this.nameOfTheSender,
      'contact': this.contact,
      'shopId': this.shopId,
      'bookingId': this.bookingId,
      'userId': this.userId,
      "createdAt": FieldValue.serverTimestamp(),
      "customTime": customTime?.toMap()
    };
  }
}
