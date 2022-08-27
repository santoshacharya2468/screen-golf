import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/book_model.dart';
import 'package:massageapp/models/booking_payment.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/widgets.dart';

class AdminPaymentScreen extends StatefulWidget {
  const AdminPaymentScreen({Key? key}) : super(key: key);

  @override
  State<AdminPaymentScreen> createState() => _AdminPaymentScreenState();
}

class _AdminPaymentScreenState extends State<AdminPaymentScreen> {
  Widget _builKeyValue({required String key, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Text(value)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop = Get.find<AuthController>().currentUser.value.shop;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(FirebaseCollections.bookingPayment)
          .where('shopId', isEqualTo: shop?.id)
          .snapshots(),
      builder:
          (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data?.docs.length ?? 0,
            itemBuilder: (_, index) {
              final doc = snapshot.data!.docs[index];
              final bookingPayment = BookingPayment.fromMap(doc.data());
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ColumnWithPadding(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      padding: const EdgeInsets.only(bottom: 06),
                      children: [
                        _builKeyValue(
                            key: translator.reservationPersonName,
                            value: bookingPayment.reservationPersonName),
                        _builKeyValue(
                            key: translator.nameOfThePersonMakingReservation,
                            value: bookingPayment.nameOfTheSender),
                        if (bookingPayment.customTime != null)
                          Builder(builder: (context) {
                            final e = bookingPayment.customTime;
                            return Text(
                              '${e?.startAt} -${e?.endAt} : ${e?.holes} 홀 :₩${e?.price} ',
                              style: Theme.of(context).textTheme.subtitle1,
                            );
                          }),
                        FutureBuilder(
                          future: FirebaseCollections.bookingRef
                              .doc(bookingPayment.bookingId)
                              .get(),
                          builder: (_,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  bookingSnpahost) {
                            if (bookingSnpahost.hasData &&
                                bookingSnpahost.data != null) {
                              final booking = BookingModel.fromJson(
                                  bookingSnpahost.data!.data()!,
                                  bookingPayment.bookingId);
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translator.booking,
                                    style:
                                        Theme.of(context).textTheme.headline6,
                                  ),
                                  Text(translator.noOfPeople +
                                      ' :' +
                                      booking.noOfClients),
                                ],
                              );
                            }
                            return SizedBox();
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Loading();
      },
    );
  }
}
