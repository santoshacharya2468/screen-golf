import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/widgets/first_tab_body/first_tab_body.dart';
import 'package:massageapp/widgets/reservation_screen_top_bar.dart';
import 'package:massageapp/widgets/widgets.dart';

class ReservationScreen extends StatefulWidget {
  const ReservationScreen({Key? key}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  int _currentIndex = 0;
  final shopController = Get.find<ShopController>();

  _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyAppBar(
        null,
        backgroundColor: Colors.white,
        showSearch: false,
        showBooking: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LocationContainer(
              text: "Nowhere 527-1",
              icon: FontAwesomeIcons.locationArrow,
            ),
            LocationContainer(
                icon: FontAwesomeIcons.calendar, text: "2055-01-30"),
            SearchWidget()
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ReservationScreenTopBar(
              initialIndex: _currentIndex,
              onChanged: _onTabChanged,
            ),
            IndexedStack(index: _currentIndex, children: [
              FirstTabBody(
                index: 0,
                massageId: shopController.massageCategories[0].id,
              ),
              FirstTabBody(
                  index: 1, massageId: shopController.massageCategories[1].id),
             // FirstTabBody(
               //   index: 2, massageId: shopController.massageCategories[2].id),
            ]),
          ],
        ),
      ),
    );
  }
}
