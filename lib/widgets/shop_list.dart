import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/screens/screens.dart';

class ShopList extends StatefulWidget {
  final List<Shop> shops;
  final VoidCallback?  onClick;

  const ShopList({ Key? key , required this.shops,this.onClick}) : super(key: key);

  @override
  _ShopListState createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  @override
  Widget build(BuildContext context) {
    return Builder(
    builder:  (_)=> GridView.builder(
        itemCount: widget.shops.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
        childAspectRatio: 4/5
        ),
        itemBuilder: (_,index){
          final shop=widget.shops[index];
          return SingleShopview(shop: shop,onClick: widget.onClick,);
        },
      ),
    );
  }
}

class SingleShopview extends StatelessWidget {
  final VoidCallback?  onClick;
  const SingleShopview({
    Key? key,
    required this.shop,this.onClick
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onClick?? ()async{
       Navigator.of(context).pushNamed(ShopDetailScreen.routeName,arguments: shop);
      },
      child: Card(
        elevation: 0.0,
        child: Column(
          children: [
            Expanded(
              child: 
            ClipRRect(
              borderRadius: BorderRadius.circular(08),
              child: CachedNetworkImage(imageUrl: shop.images[0],
              fit: BoxFit.cover,
              width: double.infinity,
              ),
            )),
            SizedBox(height:05),
            Text(shop.name,
              style: Theme.of(context).textTheme.headline6,
            )
          ],
        ),
      ),
    );
  }
}