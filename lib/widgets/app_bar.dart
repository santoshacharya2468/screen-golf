import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/screens/booking_screen.dart';
import 'package:massageapp/widgets/search_widget.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  final bool showSearch;
  final Color? backgroundColor;
  final void Function(String? query)? onSearch;
  final Shop? shop;
  final bool? shouldCenterTitle;
  final bool showBooking;
  final Widget? title;
  final double? elevation;
  final List<Widget> ?actions;

  const MyAppBar(this.shop,
      {Key? key,
        this.shouldCenterTitle = false,
        this.actions,
      this.showBooking = false,
        this.backgroundColor ,
      this.showSearch = false,
      this.title,
      this.elevation = 0,
      this.onSearch})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: elevation,
      title: title != null ? title : SizedBox(),
      centerTitle: shouldCenterTitle,
      actions: [
        if (showSearch) SearchWidget(),
        if(actions!=null)...actions!,
        if(showBooking)TextButton(onPressed: (){
          Navigator.of(context).pushNamed(BookingScreen.routeName,arguments: shop);
        }, child: Text(translator.booking)),
          
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
