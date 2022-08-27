import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/column_with_padding.dart';
import 'package:massageapp/widgets/widgets.dart';

import '../models/amin_inforamtion.dart';

class PaymentInformationScreen extends StatefulWidget {
  final Shop shop;
  static const String routeName='/payment_information_screen';
  const PaymentInformationScreen({ Key? key,required this.shop }) : super(key: key);

  @override
  State<PaymentInformationScreen> createState() => _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
 Widget _builKeyValue({required String key,required String value}){
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
       children: [
         Text(key,
          style: Theme.of(context).textTheme.headline6,
         ),
         Text(value)
       ],
     ),
   );
 }
 AdminInformation? information;
 _loadDetails()async{
  final data=await  FirebaseFirestore.instance.collection('information').doc('information').get();
  if( data.exists){
    information=AdminInformation.fromMap(data.data()!);
    if(mounted){
      setState(() {
        
      });
    }
  }

 }
 @override
  void initState() {
    super.initState();
    _loadDetails();
    _shopNameController.text=widget.shop.name;
  }
  final  TextEditingController _shopNameController=TextEditingController();
  final TextEditingController _userNameController=TextEditingController();
  final TextEditingController _phoneNumberController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  bool _processing=false;
  PaymentPackage? _selectedPackage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${translator.payment} ${translator.inforamtions}'),
      ),
      body:information==null?Loading(): SingleChildScrollView(
        child: ColumnWithPadding(
          padding: const EdgeInsets.only(
            bottom: 10
          ),
          children: [
            _builKeyValue(key: translator.adminPhone, value: information!.phoneNumber),
            _builKeyValue(key: translator.bankAccountNumber, value:information!.bankAccountNumber),
             _builKeyValue(key: translator.bankAccoutName, value: information!.acconutName),
            _builKeyValue(key: translator.bankName, value: information!.bankName),
            _builKeyValue(key: translator.payment, value: ''),
            ...information!.packages.map((e) => _builKeyValue(key: '${e.month} ${translator.months}', value: '${e.amout} 원')).toList()
           ,
            
            Form(
              key: _formKey,
              child: Column(
                children:[
                  InputSpacer(
              child: DropdownSearch<PaymentPackage>(
               label: translator.selectPackage,
               items: information?.packages??[],
               validator: (e)=>e==null?translator.required:null,
               itemAsString: (e)=>'${e!.month} ${translator.months}',
               onChanged: (e){
                 setState(() {
                   _selectedPackage=e;
                 });
               },
              ),
            ),
                  InputSpacer(child: TextFormField(
                    validator: InputValidators.validateNoEmpty,
                    controller: _shopNameController,
                    
                    decoration: InputDecoration(
                      labelText: translator.shop+' '+translator.name
                    ),
                  )),
                  InputSpacer(child: TextFormField(
                    controller: _userNameController,
                    validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                      labelText:'송금자,또는 대표자이름'
                    ),
                  )),
                   InputSpacer(child: TextFormField(
                    controller: _phoneNumberController,
                    validator: InputValidators.validatePhoneNumber,
                    decoration: InputDecoration(
                      labelText: translator.contact
                    ),
                  )),
                  InputSpacer(
                    child: InputButton(
                      state: !_processing,
                      buttonText: translator.send, onPressed: ()async{
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          _processing=true;
                        });
                      FirebaseFirestore.instance.collection(FirebaseCollections.paymentRequest).add({
                        "shopId":widget.shop.id,
                        "userId":FirebaseAuth.instance.currentUser?.uid,
                        "userName":_userNameController.text,
                        "phone":_phoneNumberController.text,
                        "shopName":_shopNameController.text,
                        'package':_selectedPackage?.toMap(),
                        "createdAt":FieldValue.serverTimestamp()
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(translator.sucess),
                        backgroundColor: Colors.green,
                      ));
                      if(mounted){
                        setState(() {
                          _processing=false;
                        });
                      }
                      }
                    }),
                  )
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}