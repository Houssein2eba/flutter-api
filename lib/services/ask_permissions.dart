import 'package:permission_handler/permission_handler.dart';

class AskPermissions {
  Future<bool> _checkPermissionStatus(Permission permission) async {
     PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true; // Permission is already granted
    } else {
      PermissionStatus newStatus = await permission.request();
      if (newStatus.isGranted) {
        return true; // Permission granted after request
      } else {
        return false; // Permission denied
      }
    }
  }


  Future<bool> askStoragePermission() async {
    return await _checkPermissionStatus(Permission.storage);
  }
}
