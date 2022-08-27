import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/admin/screens/admin_home_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_dashboard_screen.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/favorite_shop_list_screen.dart';
import 'package:massageapp/screens/login_screen.dart';
import 'package:massageapp/screens/password_change_screen.dart';
import 'package:massageapp/screens/recomended_shop_screen.dart';
import 'package:massageapp/widgets/top_visited_shop.dart';
import 'package:massageapp/widgets/widgets.dart';
import '../constant/firebase_collections.dart';
import '../get_localization.dart';
import 'user_point_screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final shopController = Get.find<ShopController>();
  final _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    shopController.fetchShops();
    _authController.fetchUserShop();
  }

  final _auth = FirebaseAuth.instance;
 Widget _buildDrawerActionButton({required String title,required VoidCallback onPressed}){
   return InkWell(
     onTap: onPressed,
     child: Container(
     //  height: 50,
       padding: const EdgeInsets.all(08) ,
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(title,
             style: Theme.of(context).textTheme.headline6!.copyWith(
               color: Colors.black
             ),
           ),
           Divider()
         ],
       ),
     ),
   );
  }
  @override
  Widget build(BuildContext context) {
    final authcontroller=Get.find<AuthController>();
    return Obx( () {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(translator.appName),
          actions: [
            SearchWidget(),
          
            FutureBuilder(
              future:  FirebaseFirestore.instance.collection(FirebaseCollections.SHOP_COLLECTIONS)
  .where('userId',
  isEqualTo: _auth.currentUser?.uid
  ).get(),
   builder: (_, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snaphsot){
      if(snaphsot.hasData && snaphsot.data!=null){
        bool hasShop=snaphsot.data!.docs.length>0;
        if(hasShop){
          authcontroller.currentUser.value.shop=Shop.fromMap(snaphsot.data!.docs.first.data(), snaphsot.data!.docs.first.id);
        }
      return  IconButton(
                  onPressed: () async {
                    if(authcontroller.currentUser.value.isSuperUser){
                    await Navigator.of(context)
                        .pushNamed(SuperAdmninDashboardScreen.routeName);
                    shopController.fetchAllShop();
                  }else if(hasShop) {
                     await Navigator.of(context)
                        .pushNamed(AdminHomeScreen.routeName);
                    shopController.fetchShops();
                  }
                  },
                  icon: Icon(Icons.dashboard));
      }
      else return SizedBox();
   },
            ),
              
          ],
        ),
        drawer: Drawer(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(),
                  accountName: Text(_auth.currentUser!.displayName ?? ''),
                  accountEmail: Text(_auth.currentUser!.email ?? '')),



                  _buildDrawerActionButton(
                    title: '${translator.my} ${translator.points} (${authcontroller.currentUser.value.points})',
                    onPressed: (){
                      Navigator.of(context).pushNamed(UserPointScreen.routeName);
                    }
                  ),

                  _buildDrawerActionButton(
                    title: translator.recomendedShop,
                    onPressed: (){
                      Navigator.of(context).pushNamed(ShopRecomendedListScreen.routeName);
                    }
                  ),
                   _buildDrawerActionButton(
                    title: translator.myFavoriteShop,
                    onPressed: (){
                      Navigator.of(context).pushNamed(FavoriteShopListScreen.routeName);
                    }
                  ),
                  _buildDrawerActionButton(
                    title: translator.changePassword,
                    onPressed: (){
                      Navigator.of(context).pushNamed(PasswordChangeScreen.routeName);
                    }
                  ),
              Row(
                children: [
                  SizedBox(
                    width: 05,
                  ),
                  Text(translator.logout),
                  IconButton(
                      onPressed: () async {
                       final value=await  DialogHelper
                       .showConfirmDialog(context,
                        confirmMessage: translator.logoutConfirm);
                       if(value==true){
                     await   Get.find<AuthController>().updateFcm(null);
                        await _auth.signOut();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            LoginScreen.routeName, (route) => false);
                       }
                      },
                      icon: Icon(
                        Icons.logout,
                        color: Colors.grey,
                      )),
                ],
              ),

              
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerImages(
              shops: shopController.shops.where((e) => e.isLease==false && e.isSell==false).toList(),
            ),
            // DepartmentList(null),
            SizedBox(height: 20,),
            Expanded(
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TopVisitedShops(),
                      Text(translator.recomendedForYou,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      
                      Expanded(
                          child: Obx(
                             () {
                               final shops=shopController.shops.where((e) => e.isLease==false && e.isSell==false).toList();
                             return  GridView.builder(
        itemCount:shops.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
        childAspectRatio: 4/5
        ),
        itemBuilder: (_,index){
          final shop=shops[index];
          return SingleShopview(shop: shop);
        },
      );
                            }
                          )),
                    ],
                  )),
            ),
          ],
        ),
      );
    });
  }
}
