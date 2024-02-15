import 'package:crafty_bay/presentation/state_holders/policy_controller.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key});

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<PolicyController>().getPolicy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Policy"),
      ),
      body: SingleChildScrollView(
        child: GetBuilder<PolicyController>(builder: (policyController) {
          return Visibility(
            visible: policyController.inProgress == false,
            replacement: const CenterCircularProgressIndicator(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("${policyController.policyModel.id ?? 0}"),
                  Text(policyController.policyModel.type ?? ""),
                  Text(policyController.policyModel.des ?? ""),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
