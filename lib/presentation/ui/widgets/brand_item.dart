import 'package:crafty_bay/data/models/brand_model.dart';
import 'package:crafty_bay/presentation/ui/screens/brand_list_screen.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrandItem extends StatelessWidget {
  const BrandItem({
    super.key,
    required this.brandModel,
  });

  final BrandModel? brandModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BrandListScreen(
            brand: brandModel?.brandName ?? "",
            brandId: brandModel?.id,
          ),
        );
      },
      child: Column(
        children: [
          Card(
            elevation: 0,
            color: AppColors.primaryColor.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ClipRRect(
                child: Image.network(
                  brandModel?.brandImg ?? "",
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            brandModel?.brandName ?? "",
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
