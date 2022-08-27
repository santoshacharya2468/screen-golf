import 'package:flutter/material.dart';
import 'package:massageapp/get_localization.dart';

class CustomBottomNavigation extends StatefulWidget {
  final void Function(int index) onPageChanged;
  final int currentIndex;

  const CustomBottomNavigation(
      {Key? key, required this.onPageChanged, required this.currentIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
 

  @override
  Widget build(BuildContext context) {
       List<Map<String, IconData>> items = [
    {translator.home: Icons.home},
   // {'Location': Icons.not_listed_location_sharp},
    {translator.search: Icons.search},
    {translator.sale+'/'+translator.lease: Icons.shop},
    {translator.bookings: Icons.bookmark},
   // {'More': Icons.more_horiz}
  ];
    return Builder(builder: (context) {
      final selectedColor = Theme.of(context).primaryColor;
      final unselectedColor = Colors.grey;
      return BottomNavigationBar(
        showSelectedLabels: true,

        showUnselectedLabels: true,
       // backgroundColor: Colors.red,
        // type: BottomNavigationBarType.fixed,
        selectedItemColor: selectedColor,
        currentIndex: widget.currentIndex,
        unselectedItemColor: unselectedColor,
        onTap: (index) {
          widget.onPageChanged(index);
        },
        items: items.map((e) {
          final bool isSelected = items.indexOf(e) == widget.currentIndex;
          return BottomNavigationBarItem(
            icon: Icon(
              e[e.keys.first],
              color: !isSelected ? Colors.grey : selectedColor,
            ),
            label: e.keys.first,
          );
        }).toList(),
      );
    });
  }
}
