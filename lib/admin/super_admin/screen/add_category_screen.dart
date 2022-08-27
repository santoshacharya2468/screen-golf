import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massageapp/controllers/shop_controller.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/models/shop_categories.dart';
import 'package:massageapp/widgets/widgets.dart';

class AddCategoryScreen extends StatefulWidget {
  static const String routeName='/add_or_edit_category';
  final ShopCategory? shopCategory;
  const AddCategoryScreen({ Key? key,this.shopCategory }) : super(key: key);

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameController=TextEditingController();
  File? pickedFile;
  late final bool isEdit;
  final  _formKey=GlobalKey<FormState>();
   bool _processing=false;
  @override
  void initState() {
    super.initState();
    isEdit=widget.shopCategory!=null;
    if(isEdit){
      _nameController.text=widget.shopCategory!.name;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit?' Edit Category ':'Add  New Category'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(height: 30,),
               InputSpacer(child: InkWell(
                 onTap: ()async{
                
                  var file=await ImagePicker().getImage(source: ImageSource.gallery);
                  if(file!=null){
                    pickedFile=File(file.path);
                    setState(() {
                      
                    });
                  }
                 },
                 child: Column(children: [
                  if(pickedFile!=null) CircleAvatar(
                    radius: 70,
                     backgroundImage: FileImage(pickedFile!),
                   )  else if (isEdit) CircleAvatar(
                      radius: 70,
                     backgroundImage: CachedNetworkImageProvider( widget.shopCategory!.iconUrl),
                   )
                   else CircleAvatar(
                      radius: 70,
                   ),
                   SizedBox(height: 05,),
                   Text('Category Image')
                 ],),
               )),
              InputSpacer(child: TextFormField(
                controller: _nameController,
                validator: (e)=>e==null || e.isEmpty?'Required':null,
                decoration: InputDecoration(
                  label: Text('Category  Name')
                ),
              )),
              InputButton(
                state: !_processing,
                buttonText: 'Save', onPressed: ()async{
                   if(_formKey.currentState!.validate()){
                    
                     if(!isEdit && pickedFile==null){
                       showErrorToasts('Please select category Image');
                       return;
                     }
                      if(mounted) setState(() {
                          _processing=true;
                       });
                     final name=_nameController.text;
                  final result=  await  Get.find<ShopController>().addOrEditCategory(
                       file: pickedFile,
                       category: widget.shopCategory,
                       name: name);
                      if(mounted) setState(() {
                          _processing=false;
                       });
                      if(result){
                        showSuccessToast('Category save Success');
                      }
                   }
                })
          ],
        )
      ),
    );
  }
}