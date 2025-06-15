
import 'package:demo/core/constant/colors_class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomSearch extends StatelessWidget {
  const CustomSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        // controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Rechercher des clients...',
          hintStyle: TextStyle(
            color: AppColors.lightTextColor,
            fontSize: 16,
          ),
          border: InputBorder.none,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.primaryColor,
              size: 20,
            ),
          ),
          suffixIcon: 1==0
              ? IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.close_rounded,
                      color: AppColors.lightTextColor,
                      size: 16,
                    ),
                  ),
                  onPressed: () {
                    // controller.searchController.clear();
                    // controller.fetchClients();
                  },
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        // onSubmitted: (query) => _performSearch(controller),
        // onChanged: (value) => controller.update(),
      ),
    );
  
  }
}