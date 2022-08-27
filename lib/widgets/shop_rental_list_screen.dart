
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/controllers/shop_controller.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/widgets.dart';

class ShopRenSaleListView extends StatefulWidget {
  const ShopRenSaleListView({Key? key}) : super(key: key);

  @override
  State<ShopRenSaleListView> createState() => _ShopRenSaleListViewState();
}

class _ShopRenSaleListViewState extends State<ShopRenSaleListView> {
  @override
  Widget build(BuildContext context) {
    final shopController = Get.find<ShopController>();
    return Column(children: [
      Obx(() {
        final List<Shop> listedShop = [];
        shopController.shops.forEach((s) {
          if (s.isSell || s.isLease) {
            listedShop.add(s);
          }
        });
        return BannerImages(shops: listedShop);
      }),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: Container(
            padding: const EdgeInsets.all(08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${translator.sale}/${translator.lease} ${translator.shop}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
                Builder(builder: (context) {
                  return Expanded(
                    child: Obx(() {
                      final listedShop = [];
                      shopController.shops.forEach((s) {
                        if (s.isSell || s.isLease) {
                          listedShop.add(s);
                        }
                      });
                      return GridView.builder(
                        itemCount: listedShop.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 4 / 5),
                        itemBuilder: (_, index) {
                          final shop = listedShop[index];
                          return SingleShopview(shop: shop);
                        },
                      );
                    }),
                  );
                }),
              ],
            )),
      )
    ]);
  }
}
