import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/book_model.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/repositories/bookings_repo.dart';

class BookingController extends GetxController {
  var userBookings = List<BookingModel>.empty(growable: true).obs;
  var shopBookings = List<BookingModel>.empty(growable: true).obs;

  var endingDate = "".obs;

  onInit() {
    super.onInit();
  }

  checkForBooking(BookingModel bookingModel) async {
    final docs = await BookingRepo().fetchShopBookings(bookingModel);
    return docs.fold((l) => l.length > 0 ? true : false,
        (r) => showErrorToasts(r.message ?? translator.error));
  }

  Future<String> makeABooking(BookingModel bookingModel) async {
    // final bool? bookingExists = await checkForBooking(bookingModel);
    //if (bookingExists != null && bookingExists) {
    // showErrorToasts("The place is booked already for the date");
    //  }
    //else {
    final ref = await FirebaseCollections.bookingRef.add(bookingModel.toJson());
    showSuccessToast(translator.sucess);
    final data = await ref.get();
    return data.id;

    //}
  }

  deleteBooking(String bookingId) async {
    final response = await BookingRepo().deleteBookingById(bookingId);
    response.fold((l) {
      userBookings.removeWhere((element) => element.bookingId == bookingId);
      showSuccessToast(translator.sucess);
    }, (r) => showErrorToasts(r.message.toString()));
  }

  fetchBookingsByUserId(String uid) async {
    final response = await BookingRepo().fetchUserBookings(uid);
    response.fold((l) {
      userBookings.value = l;
    }, (r) => showErrorToasts(r.message ?? ""));
  }

  fetchShopBookingList() async {
    Shop shop = Get.find<AuthController>().currentUser.value.shop!;
    final result = await BookingRepo().fetchShopAllBooking(shop.id);
    result.fold((l) {
      shopBookings.value = l;
    }, (r) => null);
  }

  changeStatus(String docId, int newStatus) async {
    await FirebaseFirestore.instance
        .collection(FirebaseCollections.BOOKINGS)
        .doc(docId)
        .update({'status': newStatus});
  }
}
