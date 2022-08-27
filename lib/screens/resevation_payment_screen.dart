import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/admin/models/amin_inforamtion.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/reservation_time_model.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/widgets.dart';

import '../models/booking_payment.dart';

class ReservationPaymentScreen extends StatefulWidget {
  final Shop shop;
  static const String routeName = '/reservation_payment_screen';

  const ReservationPaymentScreen({Key? key, required this.shop})
      : super(key: key);

  @override
  State<ReservationPaymentScreen> createState() =>
      _ReservationPaymentScreenState();
}

class _ReservationPaymentScreenState extends State<ReservationPaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _reservationPersonNameController = TextEditingController();
  final _reservationSenderNameController = TextEditingController();
  final _contactController = TextEditingController();
  Widget _builKeyValue({required String key, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: Theme.of(context).textTheme.headline6,
          ),
          Text(value)
        ],
      ),
    );
  }

  List<ReservationTimeModel>? _customTime;
  ReservationTimeModel? _selectedTime;
  Future<void> _fetchReservationTime() async {
    final data = await FirebaseFirestore.instance
        .collection(FirebaseCollections.customTime)
        .doc(widget.shop.id)
        .collection(FirebaseCollections.customTime)
        .get();
    _customTime = [];
    for (var i in data.docs) {
      _customTime!.add(ReservationTimeModel.fromMap(i.data(), i.id));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchReservationTime();
  }

  @override
  Widget build(BuildContext context) {
    final package = AdminInformation(
        packages: [],
        bankAccountNumber: widget.shop.bankAccountNumber ?? '--',
        bankName: widget.shop.bankName ?? '--',
        phoneNumber: widget.shop.phoneNumber ?? '--',
        acconutName: widget.shop.bankAccountHolderName ?? '--');
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.payment),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  translator.reservationPaymentConfirm,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ),
              _builKeyValue(
                  key: translator.storeContact, value: package.phoneNumber),
              _builKeyValue(
                  key: translator.bankAccountNumber,
                  value: package.bankAccountNumber),
              _builKeyValue(
                  key: translator.bankAccoutName, value: package.acconutName),
              _builKeyValue(key: translator.bankName, value: package.bankName),
              _builKeyValue(key: translator.usesFee, value: ''),
              _builKeyValue(key: '9홀 ', value: '원'),
              _builKeyValue(key: '18홀 ', value: '원'),
              SizedBox(
                height: 30,
              ),
              InputSpacer(
                child: DropdownSearch<ReservationTimeModel>(
                  selectedItem: _selectedTime,
                  items: _customTime,
                  label: translator.date + " " + translator.time,
                  onChanged: (e) {
                    setState(() {
                      _selectedTime = e;
                    });
                  },
                  itemAsString: (e) =>
                      '${e?.startAt} -${e?.endAt} : ${e?.holes} 홀 :₩${e?.price} ',
                ),
              ),
              _builKeyValue(
                  key: translator.choosePaymentForReservation, value: ''),
              InputSpacer(
                child: TextFormField(
                    controller: _reservationPersonNameController,
                    validator: (e) => InputValidators.validateNoEmpty(
                        e, 3, translator.reservationPersonName),
                    decoration: InputDecoration(
                        hintText: translator.reservationPersonName)),
              ),
              InputSpacer(
                child: TextFormField(
                    controller: _reservationSenderNameController,
                    validator: (e) => InputValidators.validateNoEmpty(
                        e, 3, translator.nameOfThePersonMakingReservation),
                    decoration: InputDecoration(
                        hintText: translator.nameOfThePersonMakingReservation)),
              ),
              InputSpacer(
                child: TextFormField(
                    controller: _contactController,
                    validator: (e) => InputValidators.validateNoEmpty(
                        e, 3, translator.contact),
                    decoration: InputDecoration(hintText: translator.contact)),
              ),
              InputButton(
                  buttonText: translator.send,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      showInfoToast(translator.processing);
                      await FirebaseFirestore.instance
                          .collection(FirebaseCollections.bookingPayment)
                          .add(BookingPayment(
                                  reservationPersonName:
                                      _reservationPersonNameController.text,
                                  nameOfTheSender:
                                      _reservationSenderNameController.text,
                                  contact: _contactController.text,
                                  shopId: widget.shop.id,
                                  customTime: _selectedTime,
                                  userId:
                                      FirebaseAuth.instance.currentUser!.uid,
                                  bookingId: widget.shop.bookingId ?? '')
                              .toMap());
                      showSuccessToast(translator.sucess);
                      Navigator.of(context).pop();
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
