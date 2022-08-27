import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/controllers/shop_controller.dart';
import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/widgets/widgets.dart';

class ShopByCategory extends StatefulWidget {
  final ShopCategory selectedCategory;
  static const String routeName='/shop/category';
  const ShopByCategory({ Key? key,required this.selectedCategory }) : super(key: key);

  @override
  _ShopByCategoryState createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  final shopController=Get.find<ShopController>();
  @override
  void initState() {
    super.initState();
    shopController.fetchShopsByCategory(widget.selectedCategory);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        title: Text(widget.selectedCategory.name),
      ),
      body: Column(
        children: [
          BannerImages(shops: shopController.shopByCategory),
          SizedBox(height: 20,),
          Expanded(child: ShopList(
            shops: shopController.shopByCategory,
          ))
        ],
      ),
      
    );
  }
}