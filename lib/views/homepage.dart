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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Clientscontroller clientController = Get.find();
  final ScrollController _scrollController = ScrollController();
  final StorageService storage = Get.find<StorageService>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
    _scrollController.addListener(_scrollListener);
  }

  Future<void> _initializeData() async {
    if (clientController.clients.isEmpty) {
      await clientController.fetchClients();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_scrollListener)
      ..dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      clientController.loadMoreClients();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        onRefresh: () => clientController.fetchClients(),
        color: AppColors.primaryColor,
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            const CustomSilverAppbar(title: 'Gestion des Clients'),
            SliverToBoxAdapter(
              child: GetBuilder<Clientscontroller>(
                builder: (controller) {
                  return Column(
                    children: [
                      const CustomClientSearch(),
                      const StatsCard(),
                      _buildClientList(controller),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: CustomFloatingAction(
        onPressed: () => _navigateToCreateClient(),
      ),
    );
  }

  Future<void> _navigateToCreateClient() async {
    final result = await Get.toNamed(RouteClass.getCreateClientRoute());
    if (result == true) {
      await clientController.fetchClients();
    }
  }

  Widget _buildClientList(Clientscontroller controller) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: HandlingDataView(
        statusRequest: controller.statusRequest,
        widget: Column(
          children: [
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.clients.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) => ClientCard(
                client: controller.clients[index],
              ),
            ),
            if (controller.isLoadingMore.value)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}