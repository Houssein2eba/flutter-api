import 'package:demo/core/class/handeling_data_view.dart';
import 'package:demo/core/constant/colors_class.dart';
import 'package:demo/core/widgets/custom_floating.dart';
import 'package:demo/core/widgets/silver_appbar.dart';

import 'package:demo/services/stored_service.dart';
import 'package:demo/wigets/client/client_card.dart';
import 'package:demo/wigets/client/custom_search.dart';

import 'package:demo/wigets/client/stats_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:demo/controllers/client/client_controller.dart';
import 'package:demo/routes/web.dart';

class HomePage extends StatelessWidget {
  final Clientscontroller clientController = Get.find();
  final StorageService storage = Get.find<StorageService>();
  
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          CustomSilverAppbar(title: 'Gestion des Clients'),
          SliverToBoxAdapter(
            child: _buildBody(),
          ),
        ],
      ),
      floatingActionButton: CustomFloatingAction(onPressed: (){
        Get.toNamed(RouteClass.getCreateClientRoute());
      }),
    );
  }

  

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: clientController.fetchClients,
      color: AppColors.primaryColor,
      backgroundColor: Colors.white,
      child: GetBuilder<Clientscontroller>(
        builder: (controller) => Column(
          children: [
            CustomClientSearch(),
            StatsCard(),
            _buildClientList(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildClientList(Clientscontroller controller) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.clients.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) =>ClientCard(client: controller.clients[index],),
        ),
      ),
    );
  }







}