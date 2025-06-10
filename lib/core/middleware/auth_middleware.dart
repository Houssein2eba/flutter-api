import 'package:demo/services/stored_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:demo/routes/web.dart'; // Assuming you have route definitions

class SanctumAuthMiddleware extends GetMiddleware {
  final _storage = Get.find<StorageService>();
  final _publicRoutes = [
    RouteClass.getLoginRoute(),
  ];

  @override
  RouteSettings? redirect(String? route)  {
    try {
      // Skip authentication check for public routes
      if (route != null && _publicRoutes.any((r) => route.startsWith(r))) {
        return null;
      }

      // Check for valid Sanctum token
      final String? token = _storage.getToken();
      if (token == null) {
        return _redirectToLogin(route);
      }

      // Additional Sanctum-specific checks can be added here
      // For example, you might want to verify the token with your backend
      
      return null; // Allow access to the route
    } catch (e) {
      Get.log('AuthMiddleware error: $e', isError: true);
      return _redirectToLogin(route);
    }
  }

  RouteSettings _redirectToLogin(String? currentRoute) {
    // Preserve the current route for redirection after login
    final returnUrl = currentRoute != null && !_publicRoutes.any((r) => currentRoute.startsWith(r))
        ? '?return=${Uri.encodeComponent(currentRoute)}'
        : '';

    return RouteSettings(
      name: '${RouteClass.getLoginRoute()}$returnUrl',
    );
  }

  
}