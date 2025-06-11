import 'package:demo/data/app_links.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class NotificationController extends GetxController {

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    initFCM();
  }

  void initFCM() async {
    await _fcm.requestPermission();
    deviceToken = await _fcm.getToken();
    print("FCM Token: $deviceToken");
    if (deviceToken != null) {
      await sendTokenToBackend(deviceToken!);
    }

    FirebaseMessaging.onMessage.listen((message) {
      print('Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Notification clicked!');
    });
  }

  Future<void> sendTokenToBackend(String token) async {
    final response = await http.post(
      Uri.parse(AppLinks.sendTokenToBackend),
      body: {'token': token},
    );
    print('Backend response: ${response.body}');
  }
}
