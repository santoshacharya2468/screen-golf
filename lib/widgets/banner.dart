import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/screens.dart';
import 'package:massageapp/widgets/widgets.dart';

class BannerImages extends StatefulWidget {
  final List<Shop> shops;
  const BannerImages({Key? key, required this.shops}) : super(key: key);

  @override
  _BannerImagesState createState() => _BannerImagesState();
}

class _BannerImagesState extends State<BannerImages> {
  @override
  Widget build(BuildContext context) {
    return Builder(
    builder:   (_) {
        if (widget.shops.length == 0) return SizedBox();
        return Container(
            height: 250,
            padding: const EdgeInsets.symmetric(vertical: 00.05),
            child:

                // CustomCarouselSlider(
                //     width: MediaQuery.of(context).size.width,
                //     height: 250,
                //     child: widget.shops.map((e) {
                //       return SingleBanner(
                //         shop: e,
                //         onPressed: () {
                //           Navigator.of(context)
                //               .pushNamed(ShopDetailScreen.routeName, arguments: e);
                //         },
                //       );
                //     }).toList());
                CarouselSlider.builder(
                    itemCount: widget.shops.length,
                    itemBuilder: (_, index, ind) {
                      final shop = widget.shops[index];
                      return SingleBanner(
                        shop: shop,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              ShopDetailScreen.routeName,
                              arguments: shop);
                        },
                      );
                    },
                    options: CarouselOptions(
                      height: 250,
                    
                      aspectRatio: 16 / 9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 10),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enlargeCenterPage: true,
                      scrollDirection: Axis.horizontal,
                    )));
      },
    );
  }
}
