
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/controllers/category_controller.dart';

import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/screens/shop_by_category.dart';


class DepartmentList extends StatefulWidget {
  final ShopCategory? selectedCategory;
  DepartmentList(this.selectedCategory);
  @override
  _DepartmentListState createState() => _DepartmentListState();
}

class _DepartmentListState extends State<DepartmentList> {
  void initState() {
   
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
   final categoryController=Get.find<CategoryController>();
        return Obx(
          ()=> Padding(
            padding: const EdgeInsets.symmetric(vertical: 08),
            child: Container(
              height: 90.0,
              width: deviceSize.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categoryController.categories.length,
                itemBuilder: (context, index) {
                  var cat = categoryController.categories[index];
                  return GestureDetector(
                    onTap: 
                        () {
                          Navigator.of(context).pushNamed(ShopByCategory.routeName,arguments: cat);
                          },
                    child: Container(
                      width: 90.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: widget.selectedCategory!=null &&  widget.selectedCategory!.id != cat.id
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            radius: 30.0,
                            backgroundImage: NetworkImage(cat.iconUrl),
                          ),
                          Center(
                            child: Text(
                              cat.name,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
     
   
  }
}
