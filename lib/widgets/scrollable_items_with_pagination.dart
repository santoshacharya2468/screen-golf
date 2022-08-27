import 'package:flutter/material.dart';
import 'loading_more_icon.dart';
import 'no_records.dart';
/// used to show scrollable items in list with pagination options 
class ScrollableItemWithPagination<T> extends StatefulWidget {
  ///this function will called whenever user reach at the bottom of the scrollable widget
  final void Function() onNewItemsDemanded;
  final List<T> items;
  final Widget Function(T item,int index) itemBuilder;
  ///optional parameter whetere to show or not loading icons at the bottom of the page
  final bool loading;
  final Future<void> Function()? onRefresh;
  // ignore: use_key_in_widget_constructors
  const ScrollableItemWithPagination({required this.onNewItemsDemanded,
  required this.itemBuilder,
  required this.items,this.loading=false,
  this.onRefresh
  });
  @override
  _ScrollableItemWithPaginationState<T> createState() => _ScrollableItemWithPaginationState<T>();
}

class _ScrollableItemWithPaginationState<T> extends State<ScrollableItemWithPagination<T>> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController=ScrollController();
    _scrollController.addListener(() {
       if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange){
           widget.onNewItemsDemanded();
          }
    });
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
  return  Stack(
            children: [
               RefreshIndicator(
                 onRefresh: widget.onRefresh??()async{},
                 child:widget.items.isEmpty?const NoRecords(): ListView.builder(
      itemCount:widget.items.length,
      
      controller: _scrollController,
      itemBuilder: (_,index){
        return widget.itemBuilder(widget.items[index],index);
      },
    ),
               ),
             if(widget.loading)const  Align(
                alignment: Alignment.bottomCenter,
                child:LoadingMoreIcon()
              )
            ],
          );
    
  }
}