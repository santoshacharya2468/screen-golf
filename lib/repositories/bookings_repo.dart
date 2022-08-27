import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/models/book_model.dart';
import 'package:massageapp/models/failure.dart';

class BookingRepo {
  Future<Either<List<BookingModel>, Failure>> fetchUserBookings(
      String uid) async {
    try {
      List<BookingModel> bookings = List.empty(growable: true);
      var data = await FirebaseCollections.bookingRef
          .where("user.userId", isEqualTo: uid)
          .get();
      data.docs
          .map((e) => bookings.add(BookingModel.fromJson(e.data(), e.id)))
          .toList();
      return Left(bookings);
    } on FirebaseException catch (e) {
      return Right(Failure(message: e.message));
    } catch (e) {
      return Right(Failure(message: e.toString()));
    }
  }

  Future<Either<bool, Failure>> deleteBookingById(String bookingId) async {
    try {
      await FirebaseCollections.bookingRef
          .doc(bookingId)
          .delete();
      return Left(true);
    } on FirebaseException catch (e) {
      return Right(Failure(message: e.code));
    } catch (e) {
      return Right(Failure(message: e.toString()));
    }
  }

  Future<Either<List<BookingModel>, Failure>> fetchShopBookings(
      BookingModel bookingModel) async {
    try {
      List<BookingModel> bookings = List.empty(growable: true);
      var data = await FirebaseCollections.bookingRef
          .where("massage-shop-id", isEqualTo: bookingModel.massageShopId)
          .where("starting-date", isEqualTo: bookingModel.startingDate)
          .get();
      data.docs
          .map((e) => bookings.add(BookingModel.fromJson(e.data(), e.id)))
          .toList();
      return Left(bookings);
    } on FirebaseException catch (e) {
      return Right(Failure(message: e.code));
    } catch (e) {
      return Right(Failure(message: e.toString()));
    }
  }
  Future<Either<List<BookingModel>,Failure>> fetchShopAllBooking(String shopId)async{
     try {
      List<BookingModel> bookings = List.empty(growable: true);
      var data = await FirebaseCollections.bookingRef
          .where("massage_shop_id", isEqualTo: shopId)
          .orderBy('created_at',descending: true)
          .get();
      data.docs
          .map((e) => bookings.add(BookingModel.fromJson(e.data(), e.id)))
          .toList();
      return Left(bookings);
    } on FirebaseException catch (e) {
      return Right(Failure(message: e.code));
    } catch (e) {
      return Right(Failure(message: e.toString()));
    }
  }
}
