String getRoomId(String id1,String id2){
  if(id1.compareTo(id2)>0){
    return id2+'_'+id1;
  }else {
    return  id1+'_'+id2;
  }
}