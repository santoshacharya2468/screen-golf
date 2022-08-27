import 'package:cloud_firestore/cloud_firestore.dart';

class ShopRecomendationVm{
  late final String address;
  late final  String name;
  late final String ownerName;
  late final String phoneNumber;
  String? recomendedBy;
  ///0 pending,1 accepted
  late int status;
 int ? pointEarn;
  ShopRecomendationVm({
    required this.name,required this.address,required this.ownerName,required this.phoneNumber,required this.recomendedBy, this.status=0
  });
  String getStatus(){
    if(status==0)return'Pending';
    else if(status==1) return 'Accepted';
    else return 'Rejected';
  }
  ShopRecomendationVm.fromMap(Map<String,dynamic> map){
     address=map['address'];
     name=map['name'];
     ownerName=map['ownerName'];
     phoneNumber=map['phoneNumber'];
     recomendedBy=map['recomendedBy'];
     status=map['status']??0;
     pointEarn=map['pointEarn'];
  }
  Map<String,dynamic> toMap(){
    return {
      'address':address,
      'name':name,
      'ownerName':ownerName,
      'phoneNumber':phoneNumber,
      'recomendedBy':recomendedBy,
      'status':status,
      'createdAt':FieldValue.serverTimestamp()
    };
  }
}