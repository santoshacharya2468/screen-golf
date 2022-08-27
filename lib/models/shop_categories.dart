class ShopCategory{
  late final String id;
  late final String name;
  late final String iconUrl;
  ShopCategory({required this.name,required this.iconUrl,required this.id});
  ShopCategory.fromMap(Map<String,dynamic> map,this.id){
    this.name=map['name'];
    this.iconUrl=map['icon'];
  }
  Map<String,dynamic> toMap(){
    return {
      'name':name,
      'icon':iconUrl
    };
  }
}