import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:massageapp/admin/controllers/notification_controller.dart';
import 'package:massageapp/admin/models/app_notification.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/application_user.dart';
import 'package:massageapp/widgets/widgets.dart';

class PushNotificationDialog extends StatefulWidget {
  final ApplicationUser user;
  const PushNotificationDialog({ Key? key,required this.user }) : super(key: key);

  @override
  _PushNotificationDialogState createState() => _PushNotificationDialogState();
}

class _PushNotificationDialogState extends State<PushNotificationDialog> {
  final _titleConroller=TextEditingController();
  final  _bodyController=TextEditingController();
  final _formKey=GlobalKey<FormState>();
  bool _processsing=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${translator.send} ${translator.push} ${translator.notification}'),),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InputSpacer(
                  child: TextFormField(
                    controller: _titleConroller,
                    validator: (e)=>e==null || e.isEmpty?translator.required:null,
                    decoration: InputDecoration(
                      label: Text('${translator.notification}  ${translator.title}')
                    ),
                  ),
                ),
                InputSpacer(
                  child: TextFormField(
                    controller: _bodyController,
                       validator: (e)=>e==null || e.isEmpty?translator.required:null,
                    decoration: InputDecoration(
                      label: Text('${translator.notification}  ${translator.description}')
                    ),
                  ),
                ),
                InputButton(
                  state: !_processsing,
                  buttonText: translator.send, onPressed: ()async{
                  if(_formKey.currentState!.validate()){
                  if(mounted)  setState(() {
                      _processsing=true;
                    });
                     final notification=AppNotification(title:_titleConroller.text , body: _bodyController.text,
                        userId: widget.user.uid,
                        shopId: Get.find<AuthController>().currentUser.value.shop?.id,
                     );
                    await   NotificationController().sendPushNotification(notification);
                    if(mounted) setState(() {
                      _processsing=false;
                    });
                    Navigator.of(context).pop();
                  }
                })
              ],
          )),
        ),
      ),
    );
  }
}