import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';

class SingleBanner extends StatelessWidget {
  final void Function()? onPressed;
  const SingleBanner({
    Key? key,
    this.onPressed,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              child: CachedNetworkImage(
                imageUrl: shop.images[0],
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
                height: 250,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    shop.name,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontSize: 20),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        shop.rating.toString(),
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.white, fontSize: 17),
                      ),
                      InkWell(
                        onTap: () {
                          print('rating');
                        },
                        child: RatingBarIndicator(
                          rating: shop.rating.toDouble(),
                          itemBuilder: (context, index) => Icon(
                            Icons.star,
                            color: Theme.of(context).primaryColor,
                          ),
                          itemCount: 5,
                          itemSize: 20.0,
                          direction: Axis.horizontal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 20,
              right: 05,
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 05),
               // width: 90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(05),
                    color: Theme.of(context).primaryColor),
                child: Center(
                  child: Text(
                   
                    shop.percentageDiscount.toString() + '% ${translator.discount}',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 16),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
