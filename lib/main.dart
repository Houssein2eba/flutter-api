
import 'package:demo/services/ask_permissions.dart';
import 'package:demo/services/initial_binding.dart';
import 'package:flutter/material.dart';
import 'package:demo/routes/web.dart';
import 'package:get/get.dart';
import 'package:demo/services/stored_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and register the StorageService
  await Get.putAsync(() => AskPermissions().askStoragePermission());
  await Get.putAsync(() => StorageService().init());
  

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo Getx',
      theme: ThemeData(
        // Primary color scheme
        colorScheme: ColorScheme.light(
          primary: Colors.blue, // Main blue color
          secondary: Colors.blue.shade600, // Secondary blue
          surface: Colors.grey.shade100, // Background color
        ),

        // App bar theme
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),

        // Text theme with bold styles
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold),
          displaySmall: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(
            fontSize: 34.0,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          titleSmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
          bodyMedium: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),

        // Button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade800, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 20,
          ),
          labelStyle: TextStyle(color: Colors.grey.shade600),
        ),
      ),

      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: Colors.blue.shade300,
          secondary: Colors.blue.shade200,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      initialBinding:InitialBinding() ,
      initialRoute: RouteClass.getDashBoardRoute(),
      getPages: RouteClass.getPages(),
    );
  }
}
