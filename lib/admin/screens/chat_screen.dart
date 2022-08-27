import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/models/message.dart';
import 'package:massageapp/constant/firebase_collections.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/get_roomid.dart';
import 'package:massageapp/helper/month_from_index.dart';
import 'package:massageapp/helper/time_status.dart';
import 'package:massageapp/models/application_user.dart';
import 'package:massageapp/models/shop.dart';
import 'package:massageapp/widgets/widgets.dart';

class AdminChatScreen extends StatefulWidget {
  static const String routeName='/admin_chat_screen';
  final ApplicationUser? user;
  final Shop? selectedShop;
  const AdminChatScreen({ Key? key, this.user,this.selectedShop }) : super(key: key);
  static  sendMessage(Message message,{bool ?isBookMark})async{
    await FirebaseFirestore.instance.collection(FirebaseCollections.MESSAGECOLLECTION).doc(message.roomId)
     .collection(FirebaseCollections.MESSAGECOLLECTION).add(message.toMap());
     final data={
      'users':[message.senderId,message.receiverId],
      'shopId':message.shopId,
      'sentAt':FieldValue.serverTimestamp(),
      'user':Get.find<AuthController>().currentUser.value.toMap(),
      'body':message.body,
     
    };
    if(isBookMark!=null){
      data['isBookMark']=isBookMark;
    }
    FirebaseFirestore.instance.collection(FirebaseCollections.MESSAGECOLLECTION).doc(message.roomId).set(data,
       SetOptions(merge: true)
      );
  }

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  late String _title;
  late final String roomId;
  late final String myId;
  @override
  void initState() {
    super.initState();
     myId=FirebaseAuth.instance.currentUser!.uid;
    roomId=getRoomId(myId, widget.selectedShop?.userId??widget.user!.uid!);
    if(widget.user!=null){
      _title= widget.user?.name??widget.user?.email??'';
    }else{
      _title=widget.selectedShop?.name??'';
    }
  }
  final _messageController=TextEditingController();
 Widget  _buildMessageBox(ApplicationUser currUser){
   return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 05),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: TextField(
                  controller: _messageController,

                  decoration: InputDecoration(
                    hintText: translator.typeAMessage,
                    contentPadding: const EdgeInsets.only(left: 20 ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          
            InkWell(
              onTap: (){
                if(_messageController.text.isNotEmpty){
                  final message=Message(
                    roomId: roomId,
                    shopId: widget.selectedShop?.id??currUser.shop!.id,
                    senderId: FirebaseAuth.instance.currentUser!.uid,
                    receiverId: widget.selectedShop?.userId??widget.user!.uid!,
                    body: _messageController.text,
                  );
                  AdminChatScreen.sendMessage(message);
                  _messageController.text='';
                }
              },
              child: Container(
                height: 50,
                width: 50,
                margin: const EdgeInsets.only(left: 05),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).primaryColor
                ),
                padding: const EdgeInsets.all(08),
                child: Center(child: Icon(Icons.send,color: Colors.white,)),
              ),
            )
          ],
        ),
      );
  }
  @override
  Widget build(BuildContext context) {
    final authUser=Get.find<AuthController>().currentUser.value;
    return Scaffold(
      
      appBar: AppBar(
        title: Text(_title.isEmpty?'---':_title),
      ),
     
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover
          )
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.
                collection(FirebaseCollections.MESSAGECOLLECTION)
                .doc(roomId)
                .collection(FirebaseCollections.MESSAGECOLLECTION)
              
                .orderBy('sentAt',descending: true)
                .snapshots()
                ,
                builder: (_,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snpashot){
                 if(snpashot.hasData && snpashot.data!=null){
                      return ListView.builder(
                        itemCount: snpashot.data?.docs.length,
                        reverse: true,
                        itemBuilder: (_,index){
                          final doc=snpashot.data!.docs[index];
                          final Message message=Message.fromMap(doc.data(),doc.id);
                           bool isMe = message.senderId == myId ? true : false;
                            return Column(
                              children: [
                                if(index==0)Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    '${message.sentAt.day} '
                                    +getMonthFromIndex(message.sentAt.month)!+' '+message.sentAt.year.toString(),
                                    style:const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey
                                    ),
                                    ),
                                ),
                                Align(
                                  alignment:
                                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:!isMe?CrossAxisAlignment.start: CrossAxisAlignment.end,
                                    children: [
                                      Bubble(
                                        margin:const BubbleEdges.all( 5),
                                        nipWidth: 3,
                                        padding:const BubbleEdges.all(0),
                                         color: message.senderId == myId
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.white,
                                        nip:isMe? BubbleNip.rightBottom:BubbleNip.no,
                                        child: Container(
                                          margin: const EdgeInsets.all(5),
                                          constraints: BoxConstraints(
                                            minHeight: 30,
                                            minWidth: 30,
                                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: message.senderId == myId
                                                  ? Theme.of(context).primaryColor
                                                  : Colors.white,
                                              borderRadius: BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                message.body,
                                                style: TextStyle(
                                                    color: isMe ? Colors.white : Colors.black),
                                              ),
                                             
                                            ],
                                          ),
                                        ),
                                      ),
                                       Text(getTimeStatus(message.sentAt))
                                    ],
                                  ),
                                ),
                              ],
                            );
                         
                        },

                      );
                 }
                 return const Loading();
                }
              ),
            ),
             _buildMessageBox(authUser)
          
         
          ],
        ),
        
      ),
     // bottomNavigationBar:  _buildMessageBox(authUser),
    );
  }
}