import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:massageapp/controllers/controllers.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/models/models.dart';
import 'package:massageapp/widgets/widgets.dart';

class AddWorkGalleryScreen extends StatefulWidget {
  static const String routeName = '/work_gallery';
  final Shop shop;
  const AddWorkGalleryScreen({Key? key, required this.shop}) : super(key: key);

  @override
  _AddWorkGalleryScreenState createState() => _AddWorkGalleryScreenState();
}

class _AddWorkGalleryScreenState extends State<AddWorkGalleryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  _buildImagePickerView() {
    return InkWell(
      onTap: () async {
        try {
          final image =
              await ImagePicker().getImage(source: ImageSource.gallery);
          if (image != null) {
            setState(() {
              _selectedImage = File(image.path);
            });
          }
        } catch (e) {}
      },
      child: Container(
        height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(08),
            border: Border.all(width: 1, color: Colors.grey[350]!)),
        child: _selectedImage != null
            ? Image.file(
                _selectedImage!,
              )
            : Center(
                child: Text(translator.image),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        null,
        title: Text(translator.image),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputSpacer(child: _buildImagePickerView()),
              InputSpacer(
                  child: TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: translator.description,
                   // hintText: 'Describe the image'
                    ),
              )),
              Builder(
                builder: (context) => InputButton(
                  buttonText: translator.submit,
                  state: _selectedImage != null,
                  onPressed: () async {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(translator.uploading+' '+translator.image)));
                    final result = await Get.find<ShopController>()
                        .addImageToWorkGallery(widget.shop.id,
                            _descriptionController.text, _selectedImage!);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    if (result != null)
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(translator.sucess)));
                    Navigator.pop(context, result);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
