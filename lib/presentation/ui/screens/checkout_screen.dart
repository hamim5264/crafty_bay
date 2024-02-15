import 'package:crafty_bay/presentation/state_holders/create_invoice_controller.dart';
import 'package:crafty_bay/presentation/ui/screens/payment_webview_screen.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<CreateInvoiceController>().createInvoice();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CheckOut"),
      ),
      body: GetBuilder<CreateInvoiceController>(
          builder: (createInvoiceController) {
        if (createInvoiceController.inProgress) {
          return const CenterCircularProgressIndicator();
        }
        final invoiceWrapper =
            createInvoiceController.paymentMethodListModel.data!.first;
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: "Payable: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "${invoiceWrapper.payable}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "  Vat: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "${invoiceWrapper.vat}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: "  Total: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: "${invoiceWrapper.total}",
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                ListView.separated(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: invoiceWrapper.paymentMethodList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        Get.to(
                          () => PaymentWebViewScreen(
                              url: invoiceWrapper.paymentMethodList![index]
                                  .redirectGatewayURL!),
                        );
                      },
                      leading: Image.network(
                          invoiceWrapper.paymentMethodList![index].logo ?? ""),
                      title: Text(
                          invoiceWrapper.paymentMethodList![index].name ?? ""),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppColors.primaryColor,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
