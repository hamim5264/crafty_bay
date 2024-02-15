import 'package:crafty_bay/data/models/product_details_data.dart';
import 'package:crafty_bay/data/services/network_caller.dart';
import 'package:crafty_bay/data/utility/urls.dart';
import 'package:crafty_bay/presentation/state_holders/add_to_cart_controller.dart';
import 'package:crafty_bay/presentation/state_holders/auth_controller.dart';
import 'package:crafty_bay/presentation/state_holders/product_details_controller.dart';
import 'package:crafty_bay/presentation/ui/screens/auth/verify_email_screen.dart';
import 'package:crafty_bay/presentation/ui/screens/reviews_screen.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:crafty_bay/presentation/ui/widgets/product_details/color_selector.dart';
import 'package:crafty_bay/presentation/ui/widgets/product_details/product_image_carousal.dart';
import 'package:crafty_bay/presentation/ui/widgets/product_details/size_selector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.productId});

  final int productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ValueNotifier<int> _noOfItem = ValueNotifier(1);

  List<Color> colors = [
    Colors.blue,
    Colors.black,
    Colors.amber,
    Colors.red,
    Colors.green,
  ];

  List<String> sizes = [
    "S",
    "L",
    "M",
    "XL",
    "XXL",
    "XXL",
  ];

  Color? _selectedColor;
  String? _selectedSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ProductDetailsController>().getProductDetails(widget.productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product Details"),
      ),
      body: GetBuilder<ProductDetailsController>(
          builder: (productDetailsController) {
        if (productDetailsController.inProgress) {
          return const CenterCircularProgressIndicator();
        }
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProductImageCarousel(
                      urls: [
                        productDetailsController.productDetails.img1 ?? "",
                        productDetailsController.productDetails.img2 ?? "",
                        productDetailsController.productDetails.img3 ?? "",
                        productDetailsController.productDetails.img4 ?? "",
                      ],
                    ),
                    productDetailsBody(productDetailsController.productDetails),
                  ],
                ),
              ),
            ),
            priceAndAddToCartSection,
          ],
        );
      }),
    );
  }

  Padding productDetailsBody(ProductDetailsData productDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  productDetails.product?.title ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ValueListenableBuilder(
                  valueListenable: _noOfItem,
                  builder: (context, value, _) {
                    return ItemCount(
                      initialValue: value,
                      minValue: 1,
                      maxValue: 20,
                      decimalPlaces: 0,
                      step: 1,
                      color: AppColors.primaryColor,
                      onChanged: (v) {
                        _noOfItem.value = v.toInt();
                      },
                    );
                  }),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          reviewAndRatingRow(productDetails.product?.star ?? 0),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Color",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          ColorSelector(
            colors: productDetails.color
                    ?.split(",")
                    .map((e) => getColorFromString(e))
                    .toList() ??
                [],
            onChange: (selectedColor) {
              _selectedColor = selectedColor;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Size",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          SizeSelector(
            sizes: productDetails.size?.split(",") ?? [],
            onChange: (s) {
              _selectedSize = s;
            },
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            "Description",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            productDetails.des ?? "",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Row reviewAndRatingRow(int rating) {
    return Row(
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const Icon(
              Icons.star,
              size: 18,
              color: Colors.amber,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              rating.toStringAsPrecision(2),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black45,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 8,
        ),
        InkWell(
          onTap: () {
            Get.to(ReviewsScreen(
              productId: widget.productId,
            ));
          },
          child: const Text(
            "Reviews",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryColor,
            ),
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        GetBuilder<ProductDetailsController>(
            builder: (productDetailsController) {
          return InkWell(
            onTap: () async {
              final response = await NetworkCaller().getRequest(
                  Urls.createWishList(
                      productDetailsController.productDetails.product!.id ??
                          0));
              if (response.isSuccess) {
                Get.snackbar(
                  "Success",
                  "This product has been added to wish list",
                  snackPosition: SnackPosition.BOTTOM,
                  isDismissible: true,
                  duration: const Duration(seconds: 2),
                  animationDuration: const Duration(milliseconds: 1500),
                );
              } else {
                Get.snackbar(
                  "Failed",
                  productDetailsController.errorMessage,
                  snackPosition: SnackPosition.BOTTOM,
                  isDismissible: true,
                  duration: const Duration(seconds: 2),
                  animationDuration: const Duration(milliseconds: 1500),
                );
              }
            },
            child: Card(
              color: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(
                  Icons.favorite_outline_rounded,
                  size: 18,
                  color: Colors.white,
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Container get priceAndAddToCartSection {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.15),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: GetBuilder<ProductDetailsController>(
          builder: (productDetailsController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Price",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45,
                    ),
                  ),
                  Text(
                    "৳${productDetailsController.productDetails.product!.price ?? ""}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 100,
                child: GetBuilder<AddToCartController>(
                    builder: (addToCartController) {
                  return Visibility(
                    visible: addToCartController.inProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_selectedColor != null && _selectedSize != null) {
                          if (Get.find<AuthController>().isTokenNotNull) {
                            final stringColor = colorToString(_selectedColor!);
                            final response =
                                await addToCartController.addToCart(
                                    widget.productId,
                                    stringColor,
                                    _selectedSize!,
                                    _noOfItem.value);
                            if (response) {
                              // Get.showSnackbar(const GetSnackBar(
                              //   title: "Success",
                              //   message: "This product has been added to cart",
                              //   duration: Duration(seconds: 2),
                              // ),
                              // );
                              Get.snackbar(
                                "Success",
                                "This product has been added to cart",
                                snackPosition: SnackPosition.BOTTOM,
                                isDismissible: true,
                                duration: const Duration(seconds: 2),
                                animationDuration:
                                    const Duration(milliseconds: 1500),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(5),
                                icon: const Icon(
                                  Icons.done_outline,
                                  color: Colors.green,
                                ),
                              );
                            } else {
                              // Get.showSnackbar(GetSnackBar(
                              //   title: "Add to cart failed",
                              //   message: addToCartController.errorMessage,
                              //   duration: const Duration(seconds: 2),
                              // ),
                              // );
                              Get.snackbar("Add to cart failed",
                                  addToCartController.errorMessage,
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  duration: const Duration(seconds: 2),
                                  animationDuration:
                                      const Duration(milliseconds: 1500),
                                  //overlayBlur: 5,
                                  //backgroundColor: Colors.green,
                                  //colorText: Colors.white,
                                  //borderRadius: 10,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(5),
                                  icon: const Icon(
                                    Icons.cancel_rounded,
                                    color: Colors.red,
                                  ));
                            }
                          } else {
                            Get.to(() => const VerifyEmailScreen());
                            Get.snackbar(
                              "Unauthorized",
                              "You have to log in before add to cart something",
                              snackPosition: SnackPosition.BOTTOM,
                              isDismissible: true,
                              duration: const Duration(seconds: 2),
                              animationDuration:
                                  const Duration(milliseconds: 1500),
                              overlayBlur: 5,
                              backgroundColor: Colors.transparent,
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(5),
                            );
                          }
                        } else {
                          Get.showSnackbar(
                            const GetSnackBar(
                              title: "Add to cart failed",
                              message: "Please select color & size",
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: const Text("Add to Cart"),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      }),
    );
  }

  Color getColorFromString(String color) {
    color = color.toLowerCase();
    if (color == "red") {
      return Colors.red;
    } else if (color == "white") {
      return Colors.white;
    } else if (color == "green") {
      return Colors.green;
    }
    return Colors.grey;
  }

  String colorToString(Color color) {
    if (color == Colors.red) {
      return "Red";
    } else if (color == Colors.white) {
      return "White";
    } else if (color == Colors.green) {
      return "Green";
    }
    return "Grey";
  }

// Color getColorFromString(String colorCode){
//   String code = colorCode.replaceAll("#", "");
//   String hexCode = "FF$code";
//   return Color(int.parse("0x$hexCode"));
// }
//
// String colorToHashColorCode(String colorCode){
//   return colorCode.toString().replaceAll("0xff", "#").replaceAll("Color(", "").replaceAll(")", "");
// }
}
