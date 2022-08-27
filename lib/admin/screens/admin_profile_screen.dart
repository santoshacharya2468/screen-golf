import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/add_work_gallery_screen.dart';
import 'package:massageapp/widgets/widgets.dart';

import '../../constant/firebase_collections.dart';
import '../../functions/fileupload.dart';
import '../../screens/location_picker.dart';
import '../../screens/shop_rental_sale_information.dart';
import '../../widgets/column_with_padding.dart';

class AdminpProfileScreen extends StatefulWidget {
  const AdminpProfileScreen({Key? key}) : super(key: key);

  @override
  _AdminpProfileScreenState createState() => _AdminpProfileScreenState();
}

class _AdminpProfileScreenState extends State<AdminpProfileScreen> {
  final authController = Get.find<AuthController>();
  final _shopNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _discountController = TextEditingController();
  final _locationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final shopcontroller = Get.find<ShopController>();
  final _shopDescriptionController = TextEditingController();
  final _distanceKmRangeController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _bankAccountHolderNameController = TextEditingController();
  LatLng? position;
  Placemark? placemark;

  Shop? shop;
  @override
  void initState() {
    super.initState();
    shop = authController.currentUser.value.shop!;
    _shopNameController.text = shop!.name;
    _discountController.text = shop!.percentageDiscount.toString();
    _phoneNumberController.text =
        authController.currentUser.value.shop!.phoneNumber ?? '';
    _locationController.text = shop!.address;
    _shopDescriptionController.text = shop!.shopDesciption ?? '';
    _distanceKmRangeController.text = shop!.notificationKmRange.toString();
  }

  bool updating = false;
  File? pickedFile;
  Widget _buildShopOpenCloseForm() {
    return InputSpacer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${translator.shop} ${translator.open} ${translator.close} ${translator.time}'),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text('${translator.open} ${translator.at} (' +
                        (shop?.openAt ?? '') +
                        ')'),
                    DropdownButton<String>(
                        items: [
                          '12',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  child: Text(e + 'AM'),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (e) {
                          shop?.openAt = e! + 'AM';

                          setState(() {});
                        })
                  ],
                ),
                Row(
                  children: [
                    Text('${translator.close} ${translator.at} (' +
                        (shop?.closeAt ?? '') +
                        ')'),
                    DropdownButton<String>(
                        items: [
                          '12',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                          '11',
                        ]
                            .map((e) => DropdownMenuItem<String>(
                                  child: Text(e + 'PM'),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (e) {
                          shop?.closeAt = e! + 'PM';
                          setState(() {});
                        })
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var myshop = Get.find<AuthController>().currentUser.value.shop;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddWorkGalleryScreen.routeName,
              arguments: authController.currentUser.value.shop);
        },
        child: Icon(Icons.image),
      ),
      body: GetBuilder<AuthController>(builder: (authcontroller) {
        final shopController = Get.find<ShopController>();
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                InputSpacer(
                  child: InkWell(
                    onTap: () async {
                      final image = await ImagePicker()
                          .getImage(source: ImageSource.gallery);
                      if (image != null)
                        setState(() {
                          pickedFile = File(image.path);
                        });
                    },
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10)),
                      child: pickedFile != null
                          ? Image.file(
                              pickedFile!,
                            )
                          : shop?.images != null
                              ? CachedNetworkImage(imageUrl: shop!.images[0])
                              : Container(
                                  child: CachedNetworkImage(
                                      imageUrl: shop!.images[0]),
                                ),
                    ),
                  ),
                ),
                InputSpacer(
                    child: InkWell(
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => LocationPickerScreen()));
                    if (result != null) {
                      position = result['position'];
                      placemark = result['placemark'];
                      _locationController.text =
                          '${placemark?.name}, ${placemark?.postalCode}';
                      setState(() {});
                    }
                  },
                  child: AbsorbPointer(
                    absorbing: true,
                    child: TextFormField(
                      validator: (e) =>
                          e == null || e.isEmpty ? translator.required : null,
                      controller: _locationController,
                      decoration: InputDecoration(
                          label:
                              Text('${translator.shop} ${translator.address}'),
                          border: OutlineInputBorder()),
                    ),
                  ),
                )),
                InputSpacer(
                    child: TextFormField(
                        controller: _shopNameController,
                        decoration: InputDecoration(
                            label:
                                Text('${translator.shop} ${translator.name}'),
                            border: OutlineInputBorder()),
                        validator: InputValidators.validateName)),

                //bank inforamtion
                InputSpacer(
                    child: TextFormField(
                  controller: _bankAccountNumberController,
                  decoration: InputDecoration(
                      label: Text(translator.bankAccountNumber),
                      border: OutlineInputBorder()),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _bankAccountHolderNameController,
                  decoration: InputDecoration(
                      label: Text(translator.bankAccoutName),
                      border: OutlineInputBorder()),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _bankNameController,
                  decoration: InputDecoration(
                      label: Text(translator.bankName),
                      border: OutlineInputBorder()),
                )),

                //bank information
                //
                InputSpacer(
                    child: TextFormField(
                        controller: _phoneNumberController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                            label: Text(
                                '${translator.phone} ${translator.number}'),
                            border: OutlineInputBorder()),
                        validator: InputValidators.validatePhoneNumber)),
                InputSpacer(
                    child: TextFormField(
                  controller: _discountController,
                  keyboardType: TextInputType.number,
                  validator: (e) {
                    if (e == null || e.isEmpty) return null;
                    try {
                      double.parse(e);
                      return null;
                    } catch (e) {
                      return translator.invalid;
                    }
                  },
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      label: Text(translator.discount)),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _distanceKmRangeController,
                  validator: (e) {
                    return num.tryParse(e ?? '') == null
                        ? translator.invalid
                        : null;
                  },
                  decoration: InputDecoration(
                      label: Text(translator.notificationRangeInKm),
                      border: OutlineInputBorder()),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _shopDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                      label:
                          Text('${translator.shop} ${translator.description}'),
                      border: OutlineInputBorder()),
                )),
                _buildShopOpenCloseForm(),
                SizedBox(
                  height: 50,
                ),
                InputButton(
                    buttonText: translator.update,
                    state: !updating,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String? newImageUrl;
                        if (pickedFile != null) {
                          newImageUrl = await uploadAndGetUrl(pickedFile!.path,
                              FirebaseStorage.instance.ref('shops'));
                        }
                        final updatingshop = Shop(
                          placemark: placemark ?? shop?.placemark,
                          position: position ?? shop?.position,
                          openAt: shop?.openAt,
                          isSell: shop?.isSell ?? false,
                          closeAt: shop?.closeAt,
                          purpose: shop!.purpose,
                          notificationKmRange:
                              num.parse(_distanceKmRangeController.text),
                          isLease: shop!.isLease,
                          shopDesciption: _shopDescriptionController.text,
                          phoneNumber: shop?.phoneNumber,
                          address: _locationController.text,
                          name: _shopNameController.text,
                          bankAccountHolderName:
                              _bankAccountHolderNameController.text,
                          bankAccountNumber: _bankAccountNumberController.text,
                          bankName: _bankNameController.text,
                          percentageDiscount:
                              double.parse(_discountController.text),
                          rating: shop!.rating,
                          images: newImageUrl != null
                              ? [newImageUrl]
                              : shop!.images,
                        );
                        updatingshop.id = shop!.id;
                        if (shop?.virtualNumber == null) {
                          updatingshop.phoneNumber =
                              _phoneNumberController.text;
                        }
                        setState(() {
                          updating = true;
                        });
                        await shopController.editShop(updatingshop);
                        setState(() {
                          updating = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(translator.sucess),
                          backgroundColor: Colors.green,
                        ));
                        authController.fetchUserShop();
                      }
                    }),
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(FirebaseCollections.SHOP_COLLECTIONS)
                      .doc(myshop?.id)
                      .snapshots(),
                  builder: (_,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      final Shop shop = Shop.fromMap(
                          snapshot.data!.data()!, snapshot.data!.id);
                      bool _isLease = shop.isLease;

                      return SingleChildScrollView(
                        child: ColumnWithPadding(
                          padding: const EdgeInsets.only(bottom: 30),
                          children: [
                            if (shop.isSell)
                              SellInformationFill(
                                shop: shop,
                              ),
                            if (_isLease)
                              RentalInoformationFill(
                                shop: shop,
                              ),
                            // if(!_isLease && !shop.isLease)...[
                            //   RentalInoformationFill(
                            //   shop: shop,
                            // ),
                            // SellInformationFill(
                            //   shop: shop,
                            // )
                            // ]
                          ],
                        ),
                      );
                    }
                    return Loading();
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
