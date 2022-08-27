import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/dialog_helper.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/app_bar.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  _MyBookingsScreenState createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final bookingController = Get.find<BookingController>();
  final authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    bookingController
        .fetchBookingsByUserId(authController.auth.currentUser!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        null,
        shouldCenterTitle: true,
        title: Text("${translator.my} ${translator.bookings}"),
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: bookingController.userBookings.length,
          itemBuilder: (context, index) {
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseCollections.shopRef
                  .doc(bookingController.userBookings[index].massageShopId)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  DocumentSnapshot doc = snapshot.data!;
                  if (doc.exists) {
                    var booking = bookingController.userBookings[index];
                    Shop shop = Shop.fromMap(
                        doc.data() as Map<String, dynamic>, doc.id);
                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                            imageUrl: shop.images.first,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(shop.name),
                        
                        trailing:booking.status==0? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: ()async {
                          final status=await   DialogHelper.showConfirmDialog(context, confirmMessage: translator.bookingDeleteConfirm);
                            
                             if(status==true){
                            bookingController
                                .deleteBooking(booking.bookingId ?? "");
                             }
                          },
                        ):SizedBox(),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                                SizedBox(height: 05,),
                            Text('${translator.companioNumber} : ${booking.noOfClients}'),
                            SizedBox(height: 05,),
                            Text('${translator.visiting} ${translator.time} ${booking.visitingTime}'),
                            SizedBox(height: 05,),
                            Text(booking.startingDate == booking.endingDate
                                ? "${booking.startingDate}"
                                : "${booking.startingDate} - ${booking.endingDate}"),
                                SizedBox(height: 05,),

                            Text('${translator.status} : ${booking.getStatus}')    
                            
                          ],
                        ),
                      ),
                    );
                  }
                }
                return SizedBox();
              },
            );
          },
        ),
      ),
    );
  }
}
