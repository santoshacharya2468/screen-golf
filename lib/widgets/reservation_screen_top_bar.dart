import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/widgets/reservation_scr_button.dart';

class ReservationScreenTopBar extends StatefulWidget {
  final Function(int index) onChanged;
  final int initialIndex;

  const ReservationScreenTopBar(
      {Key? key, required this.onChanged, required this.initialIndex})
      : super(key: key);

  @override
  _ReservationScreenTopBarState createState() =>
      _ReservationScreenTopBarState();
}

class _ReservationScreenTopBarState extends State<ReservationScreenTopBar> {
  final shopController = Get.find<ShopController>();

  Widget _buildTopBar(String title, int index) {
    bool isSelected = index == widget.initialIndex;
    return LayoutBuilder(builder: (context, constraint) {
      return InkWell(
        onTap: () {
          widget.onChanged(index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: constraint.maxHeight * 0.5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey)),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        height: 1,
                        width: 50)
                  ],
                ))
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:
                  List.generate(shopController.massageCategories.length, (i) {
                return _buildTopBar(
                    shopController.massageCategories[i].title, i);
              }),
            ),
          )),
          ReservationScreenButton(
            onTap: () {},
            buttonColor: Colors.blue,
            title: "Lorem",
          ),
          ReservationScreenButton(
              onTap: () {}, buttonColor: Colors.grey, title: "Ipsum")
        ],
      ),
    );
  }
}
