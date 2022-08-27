import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massageapp/admin/screens/payment_information_screen.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/functions/fileupload.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/nav_screen.dart';
import 'package:massageapp/widgets/input_spacer.dart';
import 'package:massageapp/widgets/password_field.dart';

import 'location_picker.dart';

class ShopRegisteScreen extends StatefulWidget {
  static const String routeName = '/register_shop';

  const ShopRegisteScreen({Key? key}) : super(key: key);

  @override
  _ShopRegisteScreenState createState() => _ShopRegisteScreenState();
}

class _ShopRegisteScreenState extends State<ShopRegisteScreen> {
  final authController = Get.find<AuthController>();
  final shopController = Get.find<ShopController>();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController=TextEditingController();
  final _phoneController=TextEditingController();
  final _desctiptionController=TextEditingController();
  File? pickedFile;
  bool _processing = false;
  LatLng ? position;
  Placemark ? placemark;

  @override
  void initState() {
    super.initState();
  }
  bool _isSell=false;
  bool _isLease=false;
  final List<String> _purpose=['Reservation','Sale','Lease',];
  String _selectedPurpose='Reservation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.newStoreRegistration),
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
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: pickedFile != null
                        ? Image.file(
                           pickedFile!,
                          )
                        : Container(
                           
                            decoration: BoxDecoration(
                               color: Colors.grey[300],
                               borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                  ),
                ),
              ),
              Text(translator.shop+' ' +translator.image),
              InputSpacer(
                  child: DropdownSearch<String>(
              
                //ignore:deprecated_member_use
                label: translator.selectPurpose,
                mode: Mode.MENU,
                items: _purpose,
                itemAsString: (s) => s=='Reservation'?translator.reservation:s=='Sale'?translator.sale:s=='Lease'?translator.lease:s??'',
                validator: (v) => v == null ? translator.required : null,
                onChanged: (e) {
                  setState(() {
                    _selectedPurpose = e!;
                    _isSell=e.contains('Sale');
                    _isLease=e.contains('Lease');
                  });
                },
              )),
               if(_isSell) _buildSaleInformationForm(),
               if(_isLease) _buildLeaseInformationForm(),
     
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
                           label: Text(translator.shop+' '+translator.address)
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
              InputSpacer(
                  child: TextFormField(
                controller: _emailController,
                validator: (v) {
                  if (GetUtils.isEmail(v ?? '')) {
                    return null;
                  }
                  return translator.invalidEmail;
                },
                decoration: InputDecoration(labelText: translator.email),
              )),
              InputSpacer(
                  child: PasswordField(
                controller: _passwordController,
              
                validator: InputValidators.validatePassword,
               labelText: translator.password,
              )),
              InputSpacer(
                  child: TextFormField(
                controller: _nameController,
                validator: (e) {
                  return e == null || e.isEmpty
                      ? translator.required
                      : e.length < 3
                          ? '${translator.minimum} 3 ${translator.characters}'
                          : null;
                },
                decoration: InputDecoration(labelText: translator.shop+' '+translator.name),
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
                decoration: InputDecoration(labelText: translator.contact),
              )),
               InputSpacer(
                  child: TextFormField(
                controller: _desctiptionController,
                 maxLines:3,
                validator: (e) {
                  return e == null || e.isEmpty
                      ? translator.required
                    
                          : null;
                },
                decoration: InputDecoration(labelText: translator.description),
              )),
              InputSpacer(
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    
                    onPressed:_processing?(){}: () async {
                      if (pickedFile == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(translator.shop+' '+translator.image+' '+translator.required)));
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        // if (_selectedCategory == null) {
                        //   return null;
                        // }
                        setState(() {
                          _processing = true;
                        });
                        final result =
                            await authController.registerWithEmailAndPassword(
                                email: _emailController.text,
                                name: '',
                                password: _passwordController.text);
                                if(result==null)
                                {
                                if(mounted)  setState(() {
                                    _processing=false;
                                  });
                                return;
                                }
                        final imageUrl = await uploadAndGetUrl(pickedFile!.path,
                            FirebaseStorage.instance.ref('shops'));
                        
                          final Shop shop = Shop(
                              name: _nameController.text,
                              position: position,
                              isActive: false,
                              isSell: _isSell,
                              purpose: _selectedPurpose,
                              isLease: _isLease,
                             phoneNumber: _phoneController.text,
                              placemark: placemark,
                              address: _locationController.text,
                              shopDesciption: _desctiptionController.text,
                              percentageDiscount: 0,
                              rating: 0,
                              averageMonthlyVisitor: int.tryParse(_visitorcontroller.text)??0,
                              images: [imageUrl],
                              userId: result.user?.uid,
                              deposit: _saleDepositController.text,
                              sellPrice: _salePurchaseController.text,
                              facility: _saleFacilityController.text,
                              monthlyRent: _rentMonthlyController.text,
                              equiptmentFee: _rentEquiptmentController.text,
                              rentalPrice: _rentalController.text,
                              );
                          await Get.find<ShopController>().addNewShop(shop);
                        await   Navigator.of(context).pushNamed(PaymentInformationScreen.routeName, 
                           
                         arguments: shop);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              NavigationScreen.routeName, (route) => false);
                        
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                         _processing?Colors.grey:   Theme.of(context).primaryColor)
                            ),
                    child: Text(!_processing ? translator.registration : translator.processing),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
   final _saleDepositController=TextEditingController();
  final _saleFacilityController=TextEditingController();
  final  _salePurchaseController=TextEditingController();
  final _visitorcontroller=TextEditingController();
 Widget _buildSaleInformationForm(){
    return  Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputSpacer(
            child: Text(translator.sale+" "+translator.inforamtions,
             style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Column(
            children: [
                 InputSpacer(
                        child: TextFormField(
                           controller: _saleDepositController,
                           validator: InputValidators.validateNoEmpty,
                          decoration: InputDecoration(
                             labelText: translator.depositMonthlyRent
                          ),
                        ),
                      ),
                      InputSpacer(
                        child: TextFormField(
                           controller: _salePurchaseController,
                             validator: InputValidators.validateNoEmpty,
                          decoration: InputDecoration(
                             labelText: translator.purchasePrice
                          ),
                        ),
                      ),
                      InputSpacer(
                        child: TextFormField(
                           controller: _saleFacilityController,
                            validator: InputValidators.validateNoEmpty,
                          decoration: InputDecoration(
                             labelText: translator.facilityEquipmentFee
                          ),
                        ),
                      ),
                      InputSpacer(
                        child: TextFormField(
                           controller: _visitorcontroller,
                           keyboardType: TextInputType.number,
                            validator: InputValidators.validateNoEmpty,
                          decoration: InputDecoration(
                             labelText: translator.averageMonthlyNumberOfVisitors
                          ),
                        ),
                      ),
            ],
          ),
        ],
      ),
    );
  }


 final _rentMonthlyController=TextEditingController();
  final _rentEquiptmentController=TextEditingController();
final  _rentalController=TextEditingController();
Widget _buildLeaseInformationForm(){
 return Card(
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       InputSpacer(
         child: Text(translator.lease+' '+translator.inforamtions
          ,
           style: Theme.of(context).textTheme.headline6,
         ),
       ),
       Column(
         children: [
           InputSpacer(
             child: TextFormField(
                controller: _rentMonthlyController,
                validator: InputValidators.validateNoEmpty,
               decoration: InputDecoration(
                  labelText: translator.depositMonthlyRent
               ),
             ),
           ),
           InputSpacer(
             child: TextFormField(
                controller: _rentEquiptmentController,
                  validator: InputValidators.validateNoEmpty,
               decoration: InputDecoration(
                  labelText:translator.facilityEquipmentFee
               ),
             ),
           ),
           InputSpacer(
             child: TextFormField(
                controller: _rentalController,
                 validator: InputValidators.validateNoEmpty,
               decoration: InputDecoration(
                  labelText: translator.rentalPrice
               ),
             ),
           ),
           InputSpacer(
                        child: TextFormField(
                           controller: _visitorcontroller,
                           keyboardType: TextInputType.number,
                            validator: InputValidators.validateNoEmpty,
                          decoration: InputDecoration(
                             labelText: translator.averageMonthlyNumberOfVisitors
                          ),
                        ),
                      ),
           ]),
     ],
   ),
 );
 }

}
