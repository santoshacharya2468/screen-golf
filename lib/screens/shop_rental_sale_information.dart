import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/shop_rental_list_screen.dart';
import 'package:massageapp/widgets/widgets.dart';

class ShopRentalSaleScreen extends StatefulWidget {
  const ShopRentalSaleScreen({ Key? key }) : super(key: key);

  @override
  State<ShopRentalSaleScreen> createState() => _ShopRentalSaleScreenState();
}

class _ShopRentalSaleScreenState extends State<ShopRentalSaleScreen> {

  @override
  Widget build(BuildContext context) {
   
      return Scaffold(
        appBar: MyAppBar(null,title: Text(translator.sale+'/'+translator.lease+" "+translator.shop),),
        body: ShopRenSaleListView());
  
  }
}
class SellInformationFill extends StatefulWidget {
  
  final Shop shop;
  const SellInformationFill({ Key? key,required this.shop }) : super(key: key);

  @override
  State<SellInformationFill> createState() => _SellInformationFillState();
}

class _SellInformationFillState extends State<SellInformationFill> {
  final _saleDepositController=TextEditingController();
  final _saleFacilityController=TextEditingController();
  final  _salePurchaseController=TextEditingController();
  final _visitorController=TextEditingController();
  @override
  void initState() {
    super.initState();
    _saleDepositController.text=widget.shop.deposit??'';
    _saleFacilityController.text=widget.shop.facility??'';
    _salePurchaseController.text=widget.shop.sellPrice??'';
    _visitorController.text=(widget.shop.averageMonthlyVisitor??0).toString();
  }
  final _saleFormKey=GlobalKey<FormState>();
  bool _procesing=false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputSpacer(child: Text('${translator.sale} ${translator.inforamtions}',
            style: Theme.of(context).textTheme.headline6,
          )),
          Form(
            key: _saleFormKey,
            child: Column(
              children: [
                InputSpacer(
                  child: TextFormField(
                     controller: _saleDepositController,
                     keyboardType: TextInputType.number,
                     validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: translator.depositMonthlyRent
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                     controller: _salePurchaseController,
                      keyboardType: TextInputType.number,
                       validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: '${translator.sale}/${translator.lease} ${translator.price}'
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                     controller: _saleFacilityController,
                      keyboardType: TextInputType.number,
                      validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: translator.facilityEquipmentFee
                    ),
                  ),
                ),
                 InputSpacer(
                  child: TextFormField(
                     controller: _visitorController,
                      validator: InputValidators.validateNoEmpty,
                      keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                       labelText: translator.averageMonthlyNumberOfVisitors
                    ),
                  ),
                ),
                InputButton(
                  state: !_procesing,
                  buttonText: translator.update, onPressed: ()async{
                    if(_saleFormKey.currentState?.validate()==true){
                  if(mounted)  setState(() {
                        _procesing=true;
                    });
                 await  FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS).doc(
                   widget.shop.id
                 ).update({
                     'deposit':_saleDepositController.text,
                    'sellPrice':_salePurchaseController.text,
                   'facility':_saleFacilityController.text,
                    'averageMonthlyVisitor':int.parse(_visitorController.text),
                     'isSell':true,
                     'isLease':false,
                   });
                   showSuccessToast(translator.sucess);
                   if(mounted)  setState(() {
                        _procesing=false;
                    });
                    }

                })

              ],
            ),
            
          ),
        ],
      ),
    );
  }
}

class RentalInoformationFill extends StatefulWidget {
  final Shop shop;
  const RentalInoformationFill({ Key? key,required this.shop }) : super(key: key);

  @override
  State<RentalInoformationFill> createState() => _RentalInoformationFillState();
}

class _RentalInoformationFillState extends State<RentalInoformationFill> {
    final _rentMonthlyController=TextEditingController();
  final _rentEquiptmentController=TextEditingController();
  final  _rentalController=TextEditingController();
  final _rentFormKey=GlobalKey<FormState>();
    final _visitorController=TextEditingController();
  bool _procesing=false;
  @override
  void initState() {
    super.initState();
    _rentMonthlyController.text=widget.shop.monthlyRent??'';
    _rentEquiptmentController.text=widget.shop.equiptmentFee??'';
    _rentalController.text=widget.shop.rentalPrice??'';
    _visitorController.text=(widget.shop.averageMonthlyVisitor??0).toString();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputSpacer(child: Text('${translator.lease} ${translator.inforamtions}',
            style: Theme.of(context).textTheme.headline6,
          )),
          Form(
            key: _rentFormKey,
            child: Column(
              children: [
                InputSpacer(
                  child: TextFormField(
                     controller: _rentMonthlyController,
                      keyboardType: TextInputType.number,
                     validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: translator.depositMonthlyRent
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                     controller: _rentEquiptmentController,
                      keyboardType: TextInputType.number,
                       validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: translator.facilityEquipmentFee
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                     controller: _rentalController,
                      keyboardType: TextInputType.number,
                      validator: InputValidators.validateNoEmpty,
                    decoration: InputDecoration(
                       labelText: '${translator.sale}/${translator.lease} ${translator.price}'
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                     controller: _visitorController,
                      validator: InputValidators.validateNoEmpty,
                      keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                       labelText: translator.averageMonthlyNumberOfVisitors
                    ),
                  ),
                ),
                InputButton(
                  state: !_procesing,
                  buttonText: translator.update, onPressed: ()async{
                    if(_rentFormKey.currentState?.validate()==true){
                  if(mounted)  setState(() {
                        _procesing=true;
                    });
                 await  FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS).doc(
                   widget.shop.id
                 ).update({
                   'monthlyRent':_rentMonthlyController.text,
                    'equiptmentFee':_rentEquiptmentController.text,
                    'rentalPrice':_rentalController.text,
                    'isLease':true,
                    'isSell':false,
                   'averageMonthlyVisitor':int.parse(_visitorController.text),

                   });
                   showSuccessToast(translator.sucess);
                   if(mounted)  setState(() {
                        _procesing=false;
                    });
                    }

                })

              ],
            ),
            
          ),
        ],
      ),
    );
  }
}


