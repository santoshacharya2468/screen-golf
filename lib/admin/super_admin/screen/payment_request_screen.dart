import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:massageapp/admin/models/amin_inforamtion.dart';
import 'package:massageapp/constant/constants.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/widgets/widgets.dart';

class PaymentRequestScreen extends StatefulWidget {
  static const String routeName='/user_paymentS_screen';
  const PaymentRequestScreen({Key? key}) : super(key: key);

  @override
  State<PaymentRequestScreen> createState() => _PaymentRequestScreenState();
}

class _PaymentRequestScreenState extends State<PaymentRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        null,
        title: Text(translator.payment),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(FirebaseCollections.paymentRequest).orderBy('createdAt',descending: true).snapshots(),
        builder: (_,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>> snapshot){
          if(snapshot.hasData && snapshot.data!=null){
            final docs=snapshot.data!.docs;
            return ListView.builder(
               itemCount: docs.length,
               itemBuilder: (_,index){
                 final doc=docs[index];
                  final data=doc.data();
                  
                  final PaymentPackage package=PaymentPackage.fromMap(data['package']);
                  final date=(data['createdAt'] as Timestamp).toDate();
                 return Card(child:ListTile(
                   title: Text(translator.store+' : '+data['shopName']),
                   subtitle: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(translator.user+' : '+data['userName']),
                       Text(translator.contact+' : '+ data['phone']),
                       Text(translator.selectPackage+' : '+'${package.month} ${translator.months} :${package.amout} 원'),
                       Text(translator.date+' : '+DateFormat('EEE, M/d/y :hh:mm:a').format(date))
                     ],
                   ),
                 ));
               },
            );
          }
          return const Loading();
        },
      ),
    );
  }
}