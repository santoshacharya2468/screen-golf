import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/models/dashboard_item.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';

class AdminTopBar extends StatefulWidget {
  final Function(int index) onChanged;
  final int initialIndex;
  const AdminTopBar(
      {Key? key, required this.initialIndex, required this.onChanged})
      : super(key: key);

  @override
  _AdminTopBarState createState() => _AdminTopBarState();
}

class _AdminTopBarState extends State<AdminTopBar> {
  final List<DashboardIcon> _icons = [
    DashboardIcon(
      text: translator.users,
      iconData: Icons.store,
      isSelected: false,
    ),
    DashboardIcon(
      text: translator.profile,
      iconData: Icons.list,
      isSelected: false,
    ),
    DashboardIcon(
      text: translator.bookings,
      iconData: Icons.adjust,
      isSelected: false,
    ),
    DashboardIcon(
      text: translator.visit,
      iconData: Icons.mouse,
      isSelected: false,
    ),
    DashboardIcon(
      text: translator.payment,
      iconData: Icons.payment,
      isSelected: false,
    ),
    DashboardIcon(
      text: translator.customTime,
      iconData: Icons.timer,
      isSelected: false,
    ),
  ];

  Widget _buildIcon(DashboardIcon icon) {
    return Builder(builder: (
      context,
    ) {
      return Padding(
        padding: const EdgeInsets.only(right: 08, top: 08),
        child: InkWell(
          onTap: () {
            widget.onChanged(_icons.indexOf(icon));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: icon.isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.black,
                //to take half available height mulitply with factor
                //the factor of 0.25 means it occupies 50% of parent height
                radius: 15,
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Icon(
                      icon.iconData,
                      color: Colors.white,
                      size: 20,
                    );
                  },
                ),
              ),
              Container(
                height: 60,
                child: Text(
                  icon.text,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  //minFontSize: 10.0,
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            height: 80,
            margin: const EdgeInsets.all(8),
            width: 060,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: authController.currentUser.value.shop!.images[0],
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
              child: Container(
            // height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _icons.map((e) {
                if (widget.initialIndex == _icons.indexOf(e)) {
                  e.isSelected = true;
                } else {
                  e.isSelected = false;
                }
                return _buildIcon(e);
              }).toList(),
            ),
          ))
        ],
      ),
    );
  }
}
