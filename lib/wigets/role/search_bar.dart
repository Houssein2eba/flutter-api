import 'package:demo/controllers/role/roles_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class BuildSearchBar extends GetView<RolesController> {
  const BuildSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        
        decoration: InputDecoration(
          hintText: 'Search roles...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  
  }
}

