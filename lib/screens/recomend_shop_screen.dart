
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/instance_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massageapp/controllers/auth_controller.dart';
import 'package:massageapp/controllers/shop_controller.dart';
import 'package:massageapp/functions/fileupload.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/widgets.dart';

import 'location_picker.dart';

class RecomendShopScreen extends StatefulWidget {
  static const String  routeName='/shop_recomend_screen';
  const RecomendShopScreen({ Key? key }) : super(key: key);

  @override
  State<RecomendShopScreen> createState() => _RecomendShopScreenState();
}

class _RecomendShopScreenState extends State<RecomendShopScreen> {
  final authController = Get.find<AuthController>();
  final shopController = Get.find<ShopController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController=TextEditingController();
  final _phoneController=TextEditingController();
  File? pickedFile;
  bool _processing = false;
  LatLng ? position;
  Placemark ? placemark;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.registerNewShop),
      ),
      body: SingleChildScrollView(
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
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: pickedFile != null
                        ? CircleAvatar(
                            backgroundImage: FileImage(pickedFile!),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.grey,
                          ),
                  ),
                ),
              ),
              Text(translator.image),
              // InputSpacer(
              //     child: DropdownSearch<ShopCategory>(
              //   maxHeight: 150,
              //   //ignore:deprecated_member_use
              //   label: 'Select Category',
              //   mode: Mode.MENU,
              //   items: shopController.allCategories,
              //   itemAsString: (s) => s!.name,
              //   validator: (v) => v == null ? 'Required' : null,
              //   onChanged: (e) {
              //     setState(() {
              //       _selectedCategory = e;
              //     });
              //   },
              // )),

     
               InputSpacer(child: GestureDetector(
                 onTap: ()async{
        //            LocationResult? result = await Navigator.of(context).push(MaterialPageRoute(
        // builder: (context) =>
        //     PlacePicker("AIzaSyApS9M9PQsV-Lzgkb_fTcDM_aWNq2-EZzY",
        //                  displayLocation: LatLng(35.9078,127.7669),
        //                 )));
        //                 print(result);

                 },
                 child: InkWell(
                   onTap: ()async{
                    final result=await Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LocationPickerScreen()));
                    if(result!=null){
                    
                      position=result['position'];
                      placemark=result['placemark'];
                      _locationController.text='${placemark?.name}, ${placemark?.postalCode}';
                      setState(() {
                        
                      });
                    }
                   },
                   child: AbsorbPointer(
                     absorbing: true,
                     child: TextFormField(
                       readOnly: true,
                         controller: _locationController,
                         validator: (e)=>e==null || e.isEmpty?translator.required:null,
                         decoration: InputDecoration(
                           label: Text('${translator.shop} ${translator.address}')
                         ),
                     ),
                   ),
                 ),
               )),
              
              // InputSpacer(
              //     child: DropdownSearch<MassageTypes>(
              //   maxHeight: 150,
              //   //ignore:deprecated_member_use
              //   label: 'Select Massage Type',
              //   mode: Mode.MENU,
              //   items: shopController.massageCategories,
              //   itemAsString: (s) => s!.title,
              //   validator: (v) => v == null ? 'Required' : null,
              //   onChanged: (e) {
              //     setState(() {
              //       _massageTypes = e;
              //     });
              //   },
              // )),
              // InputSpacer(
              //     child: TextFormField(
              //   controller: _emailController,
              //   validator: (v) {
              //     if (GetUtils.isEmail(v ?? '')) {
              //       return null;
              //     }
              //     return 'Invalid Email';
              //   },
              //   decoration: InputDecoration(labelText: 'Email Address'),
              // )),
              // InputSpacer(
              //     child: PasswordField(
              //   controller: _passwordController,
              
              //   validator: (e) {
              //     return e == null || e.isEmpty
              //         ? 'Required'
              //         : e.length < 6
              //             ? 'Min 6 Charaters'
              //             : null;
              //   },
              //  labelText: 'Password',
              // )),
              InputSpacer(
                  child: TextFormField(
                controller: _nameController,
                 validator:(e)=> InputValidators.validateNoEmpty(e,3),
                // validator: (e) {
                //   return e == null || e.isEmpty
                //       ? translator.required
                //       : e.length < 3
                //           ? 'Min 3 Charaters'
                //           : null;
                // },
                decoration: InputDecoration(labelText: '${translator.shop} ${translator.name}'),
              )),
              InputSpacer(
                  child: TextFormField(
                controller: _phoneController,
                 keyboardType: TextInputType.phone,
                validator: (e) {
                  return e == null || e.isEmpty
                      ? translator.required
                    
                          : null;
                },
                decoration: InputDecoration(labelText: '${translator.phone} ${translator.number}'),
              )),
              InputSpacer(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    
                    onPressed:_processing?(){}: () async {
                      if (pickedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${translator.shop} ${translator.image}  ${translator.required}')));
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _processing = true;
                        });
                        
                        final imageUrl = await uploadAndGetUrl(pickedFile!.path,
                            FirebaseStorage.instance.ref('shops'));
                          final  shop = Shop(
                              name: _nameController.text,
                              position: position,
                              isSell: false,
                              isActive: false,
                              isLease: false,
                              purpose: 'Reservation',
                              recomendedBy:FirebaseAuth.instance.currentUser?.uid,
                             phoneNumber: _phoneController.text,
                              placemark: placemark,
                              address: _locationController.text,
                              percentageDiscount: 0,
                              rating: 0,
                              images: [imageUrl],
                              userId: null);
                          await Get.find<ShopController>().addNewShop(shop);
                          Navigator.of(context).pop();
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                         _processing?Colors.grey:   Theme.of(context).primaryColor)
                            ),
                    child: Text(!_processing ? translator.register : translator.processing),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}