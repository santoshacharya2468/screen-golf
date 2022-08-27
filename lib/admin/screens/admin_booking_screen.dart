import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/book_model.dart';
import 'package:massageapp/widgets/widgets.dart';
class AdminBookinListScreen extends StatefulWidget {
  const AdminBookinListScreen({ Key? key }) : super(key: key);

  @override
  State<AdminBookinListScreen> createState() => _AdminBookinListScreenState();
}

class _AdminBookinListScreenState extends State<AdminBookinListScreen> {
  @override
  Widget build(BuildContext context) {
    final shop=Get.find<AuthController>().currentUser.value.shop;
    return StreamBuilder(
       stream: FirebaseFirestore.instance.collection(FirebaseCollections.BOOKINGS).where('massage_shop_id',isEqualTo: shop?.id)
       .orderBy('created_at',descending: true)
       .snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.hasData && snapshot.data!=null){

return  ListView.builder(
         itemCount:snapshot.data!.docs.length,
         
         itemBuilder: (_,index){
           final doc=snapshot.data!.docs[index];
           final book=BookingModel.fromJson(doc.data(), doc.id);
           String namePlaceholder='';
           if(book.bookedUser.name!=null && book.bookedUser.name!.isNotEmpty){
              namePlaceholder=book.bookedUser.name!;
           }else {
             namePlaceholder=book.bookedUser.email??'';
           }
           return Card(
             
             child: ListTile(
               leading: Text('${index+1}',
                 style: Theme.of(context).textTheme.headline5,
               ),
               title: Text(translator.personName+" : "+namePlaceholder,
                 style: Theme.of(context).textTheme.bodyText2,
               ),
                trailing: PopupMenuButton(
                   onSelected: (e)async{
                     int newStatus=book.status;
                     if(e=='Accept'){
                       newStatus=1;
                     }else if(e=='Reject'){
                       newStatus=3;
                     }else if(e=='Mark As Complete'){
                        newStatus=2;
                     }
                    await  Get.find<BookingController>().changeStatus(book.bookingId??'', newStatus);
                    book.status=newStatus;
                    setState(() {
                      
                    });
                   },
                  itemBuilder: (_)=>[
                 ['Accept',translator.accept],
                 ['Reject',translator.reject],
                 ['Mark As Complete',translator.markAsComplete]
                ].map((e) => PopupMenuItem(child: Text(e.last),value: e.first,)).toList()
                ),
               subtitle: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                  //  Text('${translator.booking} ${translator.date} ${book.createdAt.toString().split(' ').first}'),
                  //   SizedBox(height: 05,),
                  
                   Text('${translator.reservationDate} : ${book.startingDate}'),
                  //  SizedBox(height: 05,),
                  //  Text('${translator.to} ${book.endingDate}'),
                  //  SizedBox(height: 05,),
                  Text('${translator.reservationTime} : ${book.visitingTime}'),
                    SizedBox(height: 05,),
                  Text('${translator.contact} : ${book.phoneNumber}',),
                   SizedBox(height: 05,),
                   Text('${translator.numberOfConpanions} : ${book.noOfClients}'),
                  SizedBox(height: 05,),
                   Text('${translator.status} : ${book.getStatus}')
                 ],
               ),
             ),
           );
         },
      );
          }
          return Loading();
        },
    );
  }
}



