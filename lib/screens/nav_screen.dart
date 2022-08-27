import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/helper/get_location.dart';
import 'package:massageapp/screens/home_screen.dart';
import 'package:massageapp/screens/search_page.dart';
import 'package:massageapp/screens/shop_rental_sale_information.dart';
import 'package:massageapp/widgets/bottom_nav_bar.dart';

import '../notification_service.dart';
import 'my_bookings_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const String routeName = "nav-screen";

  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;
  @override
  void initState() {
    _pages = [
      HomeScreen(),
     // ReservationScreen(),
      Container(),
      ShopRentalSaleScreen(),
      MyBookingsScreen(),
     // Container(),
    ];
    super.initState();
    Get.find<AuthController>().updateUser();
    _onNotifications();
    _appOpened();
  }
  _appOpened()async{
   await  Future.delayed(Duration(seconds: 3));
    final loc=await getCurrentLocation();
    if(loc!=null && !Get.find<AuthController>().currentUser.value.isSuperUser){
   FirebaseFirestore.instance.collection('AppOpen').add({
     'lat':loc.latitude,
     'lon':loc.longitude,
     'time':FieldValue.serverTimestamp(),
     'userId':FirebaseAuth.instance.currentUser?.uid
   });
    }
  }
   Future<void> _onNotifications() async {
    FirebaseMessaging.instance.getToken().then((token) {
    });
    FirebaseMessaging.instance.getInitialMessage().then((value) {
     // print('opened from notifications panel   and data is ${value?.data}');
      if (value != null) {
        NotificationService().showNotification(
            value.notification?.title ?? '',
            value.data.toString(),
            value);
      }
    });
    FirebaseMessaging.onMessage.listen((event) {
      NotificationService().showNotification(
          event.notification!.title, event.notification!.body, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onPageChanged: (index) {
          if(index==1){
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                showSearch(context: context, delegate: SearchScreen());
             });
          }
          else{
          setState(() {
            _currentIndex = index;
          });
          }
        },
      ),
    );
  }
}
