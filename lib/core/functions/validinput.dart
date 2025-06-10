import 'package:get/get.dart';

String? validInput(String val, int min, int max, String? type) {
  String value = val.trim();
  if (value.isEmpty) {
    return "please_enter_email".tr;
  }

  if (value.length < min) {
    return "${"input_min_length".tr} $min ${"characters".tr}";
  }
  if (value.length > max) {
    return "${"input_max_length".tr} $max ${"characters".tr}";
  }

  if (type == "username") {
    if (!GetUtils.isUsername(value)) {
      return "invalid_username".tr;
    }
  } else if (type == "email") {
    if (!GetUtils.isEmail(value)) {
      return "invalid_email".tr;
    }
  } else if (type == "phone") {
    if (!GetUtils.isPhoneNumber(value)) {
      return "invalid_phone".tr;
    }
    if (!RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
      return "phone_format".tr;
    }
  } else if (type == "password") {
    if (!GetUtils.isLengthGreaterThan(value, min)) {
      return "${"password".tr} ${"min_length".tr} $min ${"characters".tr}";
    }
    if (!GetUtils.isLengthLessThan(value, max)) {
      return "${"password".tr} ${"max_length".tr} $max ${"characters".tr}";
    }
  } else if (type == "emailOrPhone") {
    if (!GetUtils.isEmail(value) && !GetUtils.isPhoneNumber(value)) {
      return "invalid_email_phone".tr;
    }
    if (GetUtils.isPhoneNumber(value) && !RegExp(r'^[2-4][0-9]{7}$').hasMatch(value)) {
      return "phone_format".tr;
    }
  } else {
    return "invalid_type".tr;
  }

  return null;
}
