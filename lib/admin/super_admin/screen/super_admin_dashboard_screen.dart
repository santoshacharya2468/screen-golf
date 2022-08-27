import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/super_admin/models/dashboard_item.dart';
import 'package:massageapp/admin/super_admin/screen/payment_request_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_setting_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_shop_screen.dart';
import 'package:massageapp/admin/super_admin/screen/super_admin_user_screen.dart';
import 'package:massageapp/admin/widgets/admin_appbar.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';

class SuperAdmninDashboardScreen extends StatefulWidget {
   static const String routeName='/super_admin_dashobard';
  const SuperAdmninDashboardScreen({ Key? key }) : super(key: key);

  @override
  State<SuperAdmninDashboardScreen> createState() => _SuperAdmninDashboardScreenState();
}

class _SuperAdmninDashboardScreenState extends State<SuperAdmninDashboardScreen> {
  
  @override
  Widget build(BuildContext context) {
    final List<DashboardItem> _menu=[
     DashboardItem(
       label: translator.store,
       routeName:SuperAdminShopScreen.routeName,
       iconUrl: 'assets/store.png'
     ),
      DashboardItem(
       label: translator.users,
       routeName: SuperAdminUserScreen.routeName,
       iconUrl: 'assets/users.png'
     ),
   
      DashboardItem(
       label: translator.inforamtionSetting,
       routeName:SuperAdminSettingScreen.routeName,
       iconUrl: 'assets/settings.png'
     ),
     DashboardItem(
       label: translator.payment,
       routeName:PaymentRequestScreen.routeName,
       iconUrl: 'assets/payments.png'
     ),
  ];
    final authController=Get.find<AuthController>();
    return Scaffold(
      appBar: AdminAppBar(
       
        title: authController.currentUser.value.email!+'\n(${authController.currentUser.value.name})',
      ),
      body: GridView.count(crossAxisCount: 2,
        children: _menu.map((e) => Card(
          child: InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(e.routeName);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(e.iconUrl,
                 height: 80,
                 width: 80,
                ),
                SizedBox(height: 10,),
                Text(e.label,
                 style: TextStyle(
                   fontSize: 18, fontWeight: FontWeight.bold
                 ),
                )
              ],
            ),
          ),
        )).toList(),

      ),
    );
  }
}