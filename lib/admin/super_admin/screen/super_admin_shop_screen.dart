import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/admin/super_admin/screen/super_amin_shop_details_screen.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminShopScreen extends StatefulWidget {
  static const String routeName='/super_admin_shop_screen';
  const SuperAdminShopScreen({ Key? key }) : super(key: key);

  @override
  State<SuperAdminShopScreen> createState() => _SuperAdminShopScreenState();
}

class _SuperAdminShopScreenState extends State<SuperAdminShopScreen> {
  int _currTab=0;
  Widget _buildTabBar(List<List<String>> _tabs){
    return Container(
      height: 38,
      child: ListView(
       scrollDirection: Axis.horizontal,
        children:_tabs.map((e) => InkWell(
          onTap: (){
            setState(() {
              _currTab=_tabs.indexOf(e);
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 08,horizontal:12),
            margin: const EdgeInsets.symmetric(horizontal: 05),
            decoration: BoxDecoration(
              color: _tabs[_currTab]==e?Theme.of(context).primaryColor:Colors.grey,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Center(
              child: Text(e.last,
               style: Theme.of(context).textTheme.button!.copyWith(
                 color: Colors.white
               ),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }
 List<Shop> _filterShopByStatus(List<Shop> shops,List<List<String>> _tabs){
   switch(_tabs[_currTab].first){
     case 'All':
     return shops;
     case 'Lease/Sale':
     return shops.where((element) => element.isLease|| element.isSell).toList();
     case 'Active':
     return shops.where((element) => element.isActive).toList();
     case 'Deactive':
     return shops.where((element) => !element.isActive).toList();
     case 'Reservation':
     return shops.where((element) => !(element.isLease|| element.isSell)).toList();
     default:
     return shops;
   }
 }
  @override
  Widget build(BuildContext context) {
     final List<List<String>> _tabs= [['All',translator.all],['Reservation',translator.reservationShop],['Lease/Sale','${translator.saleRentalShop}'],['Active',translator.activeShop],['Deactive',translator.deactiveShop],];
    return Scaffold(
      appBar: AppBar(
        title: Text(translator.wholeStore),
      ),
      body: Column(
        children: [
       
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: _buildTabBar(_tabs),
          ),
          Expanded(
            child: StreamBuilder(
               stream: FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS).snapshots(),
                builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                  if(snapshot.hasData){
                    if(snapshot.data!=null && snapshot.data!.docs.length>0){
                      final List<Shop> shops=snapshot.data!.docs.map((e) => Shop.fromMap(e.data(), e.id)).toList();
                      final filterShop=_filterShopByStatus(shops,_tabs);
                      return  GridView.builder(
                        itemCount:filterShop.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                           crossAxisSpacing: 10,
                           mainAxisSpacing: 10
                        ),
                         itemBuilder: (_,index){
                           final shop=filterShop[index];
                           return SingleShopview(shop: shop,
                            onClick: (){
                              Navigator.of(context).pushNamed(SuperAdminShopDetailsScreen.routeName,arguments: shop.id);
                            },
                           );
                         });
                    }else {
                      return NoRecord();
                    }
                  }else return Loading();
                },
            ),
          ),
        ],
      ),
    );
  }
}