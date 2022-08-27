import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/screens/admin_booking_screen.dart';
import 'package:massageapp/admin/screens/admin_bookmark_user_list_screen.dart';
import 'package:massageapp/admin/screens/admin_profile_screen.dart';
import 'package:massageapp/admin/screens/admin_visit_screen.dart';
import 'package:massageapp/admin/screens/payment_information_screen.dart';
import 'package:massageapp/admin/widgets/admin_appbar.dart';
import 'package:massageapp/admin/widgets/top_bar.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';

import 'admin_payment_screen.dart';
import 'custom_reservation_time_setup_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  static const String routeName = '/admin/home';
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _currentIndex = 0;
  _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    Get.find<BookingController>().fetchShopBookingList();
  }

  final List<Widget> _fragments = [
    AdminBookmarkedUsersList(),
    AdminpProfileScreen(),
    AdminBookinListScreen(),
    AdminVisitScreen(),
    AdminPaymentScreen(),
    CustomReservationTimeSetupScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(PaymentInformationScreen.routeName,
              arguments: Get.find<AuthController>().currentUser.value.shop);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 08),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(05)),
          child: Text(
            translator.contactAdmin,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
      appBar: AdminAppBar(
        title: translator.manager,
      ),
      body: Column(
        children: [
          AdminTopBar(
            initialIndex: _currentIndex,
            onChanged: _onTabChanged,
          ),
          Expanded(
            child: IndexedStack(
              children: _fragments,
              index: _currentIndex,
            ),
          )
        ],
      ),
    );
  }
}
