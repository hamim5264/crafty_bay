import 'package:crafty_bay/data/models/cart_item.dart';
import 'package:crafty_bay/presentation/state_holders/cart_list_controller.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:item_count_number_button/item_count_number_button.dart';

class CartProductItem extends StatefulWidget {
  const CartProductItem({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  State<CartProductItem> createState() => _CartProductItemState();
}

class _CartProductItemState extends State<CartProductItem> {
  late final ValueNotifier<int> _noOfItem =
      ValueNotifier(widget.cartItem.quantity);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 4),
      child: Card(
        color: Colors.white,
        elevation: 3,
        child: Row(
          children: [
            Image.network(
              widget.cartItem.product?.image ?? "",
              width: 100,
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.cartItem.product?.title ?? "",
                              maxLines: 1,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Color: ${widget.cartItem.color ?? ""}",
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "Size: ${widget.cartItem.size ?? ""}",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GetBuilder<CartListController>(
                          builder: (cartListController) {
                        return IconButton(
                          onPressed: () {
                            cartListController
                                .deleteCartList(widget.cartItem.productId ?? 0);
                          },
                          icon: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          ),
                        );
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "৳${widget.cartItem.product?.price ?? 0}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryColor,
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
                                Get.find<CartListController>().updateQuantity(
                                    widget.cartItem.id!, _noOfItem.value);
                              },
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
