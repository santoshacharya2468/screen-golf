///groups the item by specific key  and returns the result as Map of key and list values
List<Map<B,List<T>>> groupItem<T,B>(List<T> items,{ required B Function( T item) labelBuilder,
                                   required bool Function(T a,T b)valueComparator}){
  List<Map<B,List<T>>> results=List.empty(growable: true);
   for(T a in items){
     if(results.length>0){
       if(results.where((e)=>e.keys.first==labelBuilder(a)).length>0){
         continue;
       }
     }
     results.add({labelBuilder(a):items.where((e)=>valueComparator(a,e)).toList()});
   }
  return results; 
}