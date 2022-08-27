import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/controllers/shop_controller.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/shop.dart';

class AddRatingView extends StatefulWidget {
 
  const AddRatingView({ Key? key }) : super(key: key);
  static showRatingDialog(Shop shop,BuildContext context){
    String review='';
    double rating=0;
     showDialog(context: context, builder: (context)
     =>AlertDialog(
       title: Text('${translator.rate} ${translator.shop}',
         style: TextStyle(
           fontSize: 17,
           fontWeight: FontWeight.bold,
           color: Colors.black
         ),
       ),
       content: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           TextField(
             onChanged: (e){
               review=e;
             },
             decoration: InputDecoration(
               hintText: '${translator.write} ${translator.review}'
             ),
             
           ),
           SizedBox(height: 20,),
           RatingBar.builder(
             itemSize: 25,
             initialRating: rating,
            
             glow: false,
             itemBuilder: (_,index)=>Icon(Icons.star,
              color: Colors.amber,
             ), onRatingUpdate: (e){
               rating=e;
             })
         ],
       ),
       actions: [
         OutlinedButton(onPressed: (){

           Navigator.of(context).pop();
         }, child: Text(translator.cancel)),
         OutlinedButton(onPressed: (){
           Get.find<ShopController>().writeReview(review: review, rating: rating, shopId: shop.id);
           Navigator.of(context).pop();
         }, child: Text(translator.submit))
       ],
     ));
  }

  @override
  State<AddRatingView> createState() => _AddRatingViewState();
}

class _AddRatingViewState extends State<AddRatingView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        children: [
           Text('${translator.rate} ${translator.shop}'),

        ],
      ),
    );
  }

}