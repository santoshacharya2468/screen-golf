class AppNotification{
  late final String title;
  late final  String body;
   String? userId;
   String? shopId;

  AppNotification({required this.title,required this.body,this.userId,this.shopId});
  AppNotification.fromMap(Map<String,dynamic> map){
     title=map['title'];
     body=map['body'];
     userId=map['userId'];
     shopId=map['shopId'];
    
  }
  Map<String,dynamic> toMap(){
    return {
      'title':title,
      'body':body,
      'userId':userId,
      'shopId':shopId
    };
  }
}