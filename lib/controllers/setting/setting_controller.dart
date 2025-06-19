import 'package:demo/core/class/status_request.dart';
import 'package:demo/core/functions/handeling_data.dart';
import 'package:demo/core/functions/success_dialog.dart';
import 'package:demo/data/remote/setting_data.dart';
import 'package:demo/models/setting_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  SettingData settingData = SettingData(Get.find());
  Setting? settingModel;
  StatusRequest statusRequest = StatusRequest.none;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void onInit() {
    getSetting();
    super.onInit();
  }

  Future<void> getSetting() async {
    statusRequest = StatusRequest.loading;
    update();
    var response = await settingData.getSetting();
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      settingModel = Setting.fromJson(response['setting']);
      companyNameController.text = settingModel!.companyName;
      emailController.text = settingModel!.email;
      phoneController.text = settingModel!.phone;
      addressController.text = settingModel!.address;
      update();
    } else {
      statusRequest = StatusRequest.serverException;
      update();
    }
  }

  Future<void> updateSetting() async {
    if (checkOldData()) {
    
      return;
    }
    statusRequest = StatusRequest.loading;
    update();
    Map<String, dynamic> data = {
      "company_name": companyNameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "address": addressController.text,
    };
    var response = await settingData.updateSetting(data);
    statusRequest = handlingData(response);
    if (statusRequest == StatusRequest.success) {
      getSetting();
      showSuccessDialog(message: 'Opération réussie!');
      update();
    } else {
      statusRequest = StatusRequest.serverException;
      update();
    }
  }

  bool checkOldData() {
    if (companyNameController.text == settingModel!.companyName &&
        emailController.text == settingModel!.email &&
        phoneController.text == settingModel!.phone &&
        addressController.text == settingModel!.address) {
      return true;
    } else {
      return false;
    }
  }
}
