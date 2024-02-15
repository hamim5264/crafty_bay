import 'package:crafty_bay/presentation/state_holders/send_email_otp_controller.dart';
import 'package:crafty_bay/presentation/ui/screens/auth/verify_otp_screen.dart';
import 'package:crafty_bay/presentation/ui/widgets/app_logo.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 160,
                ),
                const AppLogo(
                  height: 80,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Welcome Back",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "Please enter your email address",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _emailTEController,
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter your email";
                    }
                    //TODO: Validate email with Regex
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 24,
                ),
                GetBuilder<SendEmailOtpController>(builder: (controller) {
                  return SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final bool result = await controller
                                .sendOtpToEmail(_emailTEController.text.trim());
                            if (result) {
                              Get.to(() => VerifyOTPScreen(
                                    email: _emailTEController.text.trim(),
                                  ));
                            } else {
                              Get.snackbar(
                                "Send OTP failed",
                                controller.errorMessage,
                                isDismissible: true,
                                duration: const Duration(seconds: 2),
                                animationDuration:
                                    const Duration(milliseconds: 1500),
                                margin: const EdgeInsets.all(10),
                                padding: const EdgeInsets.all(5),
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.red,
                                ),
                              );
                              // Get.showSnackbar(
                              //   GetSnackBar(
                              //     backgroundColor: Colors.red.shade50,
                              //     title: "Send OTP Failed",
                              //     message: controller.errorMessage,
                              //     isDismissible: true,
                              //     duration: const Duration(seconds: 2),
                              //   ),
                              // );
                            }
                          }
                        },
                        child: const Text(
                          "Next",
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailTEController.dispose();
  }
}
