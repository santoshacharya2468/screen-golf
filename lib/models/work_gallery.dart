class WorkGallery{
   String? id;
 late final String imageUrl;
 late final String thumbnail;
 String ?description;
 String? shopId;
 WorkGallery.fromMap(Map<String,dynamic> map,this.id){
    this.imageUrl=map['imageUrl'];
    this.thumbnail=map['thumbnail'];
    this.description=map['description'];
     }
     Map<String,dynamic> toMap(){
       return {
         'imageUrl':this.imageUrl,
         'thumbnail':this.thumbnail,
         'description':this.description,
         'shopId':this.shopId
       };
     }
WorkGallery({required this.imageUrl,required this.thumbnail,this.description,this.shopId});
}