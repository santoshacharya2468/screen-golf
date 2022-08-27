class MassageTypes {
  late final String id;
  late final String title;
  MassageTypes.fromMap(Map<String,dynamic> map,this.id){
    this.title=map['title'];
  }
}
