import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:massageapp/admin/models/amin_inforamtion.dart';
import 'package:massageapp/functions/app_toasts.dart';
import 'package:massageapp/get_localization.dart';
import 'package:massageapp/helper/input_validator.dart';
import 'package:massageapp/widgets/widgets.dart';

class SuperAdminSettingScreen extends StatefulWidget {
  static const String routeName = '/super_admin_setting_screen';
  const SuperAdminSettingScreen({Key? key}) : super(key: key);

  @override
  State<SuperAdminSettingScreen> createState() =>
      _SuperAdminSettingScreenState();
}

class _SuperAdminSettingScreenState extends State<SuperAdminSettingScreen> {
  final _pointsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _bankAccountController = TextEditingController();
  final _bankAccountNameController=TextEditingController();
  AdminInformation? _information;

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _fetchPoints();
    _fetchAdminInformation();
    super.initState();
  }

  _fetchPoints() async {
    final data = await FirebaseFirestore.instance
        .collection('configurations')
        .doc('ip0B7nFrBqsw64xu4eiu')
        .get();
    // _kmController.text=(data.data()!['maxNotificationDistance']??'').toString();
    _pointsController.text = (data.data()!['initialPoints'] ?? '').toString();
  }

  _fetchAdminInformation() async {
    final data = await FirebaseFirestore.instance
        .collection('information')
        .doc('information')
        .get();
    if (data.exists) {
      _information = AdminInformation.fromMap(data.data()!);
      if (mounted) {
        setState(() {});
        _phoneController.text = _information!.phoneNumber;
        _bankNameController.text = _information!.bankName;
        _bankAccountController.text = _information!.bankAccountNumber;
        _bankAccountNameController.text=_information!.acconutName;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('관리자정보/패키지 설정'),
        ),
        bottomNavigationBar: InputButton(
            buttonText: translator.update,
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final information = AdminInformation(
                    packages: _information!.packages,
                    bankAccountNumber: _bankAccountController.text,
                    bankName: _bankNameController.text,
                    acconutName: _bankAccountNameController.text,
                    phoneNumber: _phoneController.text);

                await FirebaseFirestore.instance
                    .collection('information')
                    .doc('information')
                    .set(information.toJson());

                await FirebaseFirestore.instance
                    .collection('configurations')
                    .doc('configurations')
                    .set({
                  // 'maxNotificationDistance':num.parse(_kmController.text),
                  'initialPoints': num.parse(_pointsController.text)
                });
                showSuccessToast(translator.sucess);
              }
            }),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                InputSpacer(
                    child: TextFormField(
                  controller: _phoneController,
                  validator: InputValidators.validatePhoneNumber,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: translator.adminPhone),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _bankAccountController,
                   validator: InputValidators.validateNoEmpty,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: translator.bankAccountNumber),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _bankNameController,
                   validator: InputValidators.validateNoEmpty,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: translator.bankName),
                )),
                InputSpacer(
                    child: TextFormField(
                  controller: _bankAccountNameController,
                   validator: InputValidators.validateNoEmpty,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), labelText: translator.bankAccoutName),
                )),
                InputSpacer(
                  child: TextFormField(
                    controller: _pointsController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: translator.pointForShopRecomendation
                        ),
                  ),
                ),
                if (_information != null)
                  InputSpacer(
                      child: Column(
                    children: _information!.packages
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      initialValue: e.month.toString(),
                                      validator: (val) {
                                        return int.tryParse(val ?? '') == null
                                            ? translator.invalid
                                            : null;
                                      },
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        e.month = int.tryParse(val) ?? e.month;
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          label: Text(translator.months)),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    validator: (val) {
                                      return int.tryParse(val ?? '') == null
                                          ? translator.invalid
                                          : null;
                                    },
                                    onChanged: (val) {
                                      e.amout = int.tryParse(val) ?? e.amout;
                                    },
                                    initialValue: e.amout.toString(),
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        label: Text('원')),
                                  ))
                                ],
                              ),
                            ))
                        .toList(),
                  ))
              ],
            ),
          ),
        ));
  }
}
