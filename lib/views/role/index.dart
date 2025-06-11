import 'package:demo/controllers/role/roles_controller.dart';
import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/wigets/role/build_statd_card.dart';
import 'package:demo/wigets/role/roles_table.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RolesScreen extends StatelessWidget {
  RolesScreen({super.key});

  @override
  Widget build(BuildContext context) {
   RolesController rolesController =  Get.put(RolesController());

    return Scaffold(
      appBar: AppBar(title: Text('Les Roles')),
      body: GetBuilder<RolesController>(
        builder: (controller) {
          return HandlingDataView(
            statusRequest: rolesController.statusRequest,
            widget: Column(children: [BuildStatdCard(rolesCount:  rolesController.rolesCount), RolesTable()]));
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Add New Role',
        child: Icon(Icons.add),
      ),
    );
  }
}
