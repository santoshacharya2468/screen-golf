class AdminInformation{
  late String phoneNumber;
  late String bankAccountNumber;
  late String bankName;
  late String acconutName;
  late List<PaymentPackage> packages;
  AdminInformation({required this.packages, required this.bankAccountNumber, required this.bankName,required this.phoneNumber,
  required this.acconutName
  });
  AdminInformation.fromMap(Map<String,dynamic> map){
     phoneNumber=map['phoneNumber'];
     bankAccountNumber=map['bankAccountNumber'];
     bankName=map['bankName'];
     packages=(map['packages'] as List).map((e) => PaymentPackage(e['amount'], e['month'])).toList();
     acconutName=map['acconutName']??'';
  }
  Map<String,dynamic> toJson(){
    return {
      'phoneNumber':phoneNumber,
      'bankAccountNumber':bankAccountNumber,
      'bankName':bankName,
      'acconutName':acconutName,
      'packages':packages.map((e) => {'amount':e.amout,"month":e.month}).toList()
    };
  }
}



class PaymentPackage{
  late int month;
  late int amout;
  PaymentPackage(this.amout, this.month);
  Map<String,dynamic> toMap(){
    return {
      'month':month,
      "amount":amout
    };
  }
  PaymentPackage.fromMap(Map<String,dynamic> map){
     month=map['month'];
     amout=map['amount'];
  }

}