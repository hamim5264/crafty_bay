import 'package:crafty_bay/presentation/state_holders/main_bottom_controller.dart';
import 'package:crafty_bay/presentation/state_holders/product_wish_list_controller.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/presentation/ui/widgets/product_card_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductWishListController>().getProductWishList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (value) {
        Get.find<MainBottomNavController>().backToHome();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Get.find<MainBottomNavController>().backToHome();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text(
            "Wish List",
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          elevation: 3,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GetBuilder<ProductWishListController>(
              builder: (productWishListController) {
            return Visibility(
              visible: productWishListController.inProgress == false,
              replacement: const CenterCircularProgressIndicator(),
              child: GridView.builder(
                itemCount: productWishListController
                        .wishListModel.wishListItem?.length ??
                    0,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.90,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onLongPress: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Delete from wish list?",
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      productWishListController.deleteWishList(
                                          productWishListController
                                                  .wishListModel
                                                  .wishListItem![index]
                                                  .productId ??
                                              0);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    )),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "No",
                                    style: TextStyle(
                                        color: AppColors.primaryColor),
                                  ),
                                ),
                              ],
                            );
                          });
                    },
                    child: FittedBox(
                        child: ProductCardItem(
                            product: productWishListController
                                .wishListModel.wishListItem![index].product!)),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
