import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/widgets/widgets.dart';

import '../../models/reservation_time_model.dart';

class CustomReservationTimeSetupScreen extends StatefulWidget {
  static const String routeName = '/reservation_time';
  const CustomReservationTimeSetupScreen({Key? key}) : super(key: key);

  @override
  State<CustomReservationTimeSetupScreen> createState() =>
      _CustomReservationTimeSetupScreenState();
}

class _CustomReservationTimeSetupScreenState
    extends State<CustomReservationTimeSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _startAtController = TextEditingController();
  final _endAtController = TextEditingController();
  final _holesController = TextEditingController();
  final _priceController = TextEditingController();
  bool showForm = false;
  @override
  Widget build(BuildContext context) {
    final myShop = Get.find<AuthController>().currentUser.value.shop;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!showForm)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showForm = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 010, vertical: 02),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(FirebaseCollections.customTime)
                  .doc(myShop?.id)
                  .collection(FirebaseCollections.customTime)
                  .snapshots(),
              builder: (_,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.docs
                      .map((e) => ReservationTimeModel.fromMap(e.data(), e.id))
                      .toList();
                  return Column(
                    children: data
                        .map((e) => Card(
                              child: ListTile(
                                // leading: Text((data.indexOf(e) + 1).toString()),
                                trailing: IconButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection(
                                              FirebaseCollections.customTime)
                                          .doc(myShop?.id)
                                          .collection(
                                              FirebaseCollections.customTime)
                                          .doc(e.id)
                                          .delete();
                                    },
                                    icon: Icon(Icons.delete)),
                                title: Text(e.startAt + " to " + e.endAt),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(translator.price + ': ${e.price}'),
                                    Text('홀: ${e.holes}')
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  );
                }
                return SizedBox();
              },
            ),
            if (showForm)
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    InputSpacer(
                      child: Text(
                        translator.customTime,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                    InputSpacer(
                      child: TextFormField(
                        controller: _startAtController,
                        validator: InputValidators.validateNoEmpty,
                        decoration:
                            InputDecoration(labelText: translator.statAt),
                      ),
                    ),
                    InputSpacer(
                      child: TextFormField(
                        controller: _endAtController,
                        validator: InputValidators.validateNoEmpty,
                        decoration:
                            InputDecoration(labelText: translator.endAt),
                      ),
                    ),
                    InputSpacer(
                      child: TextFormField(
                        controller: _holesController,
                        validator: InputValidators.validateNoEmpty,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: translator.noOfHoles),
                      ),
                    ),
                    InputSpacer(
                      child: TextFormField(
                        controller: _priceController,
                        validator: InputValidators.validateNoEmpty,
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(labelText: translator.price),
                      ),
                    ),
                    InputButton(
                        buttonText: translator.submit,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseFirestore.instance
                                .collection(FirebaseCollections.customTime)
                                .doc(myShop?.id)
                                .collection(FirebaseCollections.customTime)
                                .add(ReservationTimeModel(
                                        startAt: _startAtController.text,
                                        endAt: _endAtController.text,
                                        holes: _holesController.text,
                                        price: num.parse(_priceController.text))
                                    .toMap());

                            showSuccessToast(translator.sucess);
                          }
                        })
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
