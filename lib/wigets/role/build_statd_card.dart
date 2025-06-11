import 'package:demo/wigets/role/stats_card.dart';
import 'package:flutter/material.dart';

class BuildStatdCard extends StatelessWidget {
  final int rolesCount;
  const BuildStatdCard({super.key, required this.rolesCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          StatsCard(title: 'Les Roles disponibles', value: rolesCount.toString(), color: Colors.orange),
        ],
      ),
    );
  }
}
