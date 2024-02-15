import 'package:crafty_bay/data/services/network_caller.dart';
import 'package:crafty_bay/data/utility/urls.dart';
import 'package:crafty_bay/presentation/state_holders/verify_otp_controller.dart';
import 'package:crafty_bay/presentation/ui/screens/auth/complete_profile_screen.dart';
import 'package:crafty_bay/presentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:crafty_bay/presentation/ui/utility/app_colors.dart';
import 'package:crafty_bay/presentation/ui/widgets/app_logo.dart';
import 'package:crafty_bay/presentation/ui/widgets/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:async';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key, required this.email});

  final String email;

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int countdown = 120;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        if (countdown == 0) {
          timer.cancel();
        } else {
          countdown--;
        }
      });
    });
  }

  void resendCode() {
    if (countdown == 0) {
      setState(() {
        countdown = 120;
      });
      startTimer();
      NetworkCaller().getRequest(Urls.sentEmailOtp(widget.email));
    }
  }

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
                  height: 120,
                ),
                const AppLogo(
                  height: 80,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "Enter OTP Code",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  "A 4 digit OTP code has been sent",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(
                  height: 24,
                ),
                PinCodeTextField(
                  controller: _otpTEController,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  keyboardType: TextInputType.number,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.transparent,
                    inactiveFillColor: Colors.transparent,
                    inactiveColor: AppColors.primaryColor,
                    selectedFillColor: Colors.transparent,
                    selectedColor: Colors.orange,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {},
                  appContext: context,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<VerifyOTPController>(
                      builder: (verifyOtpController) {
                    return Visibility(
                      visible: verifyOtpController.inProgress == false,
                      replacement: const CenterCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final bool response = await verifyOtpController
                                .verifyOTP(widget.email, _otpTEController.text);
                            if (response) {
                              if (verifyOtpController
                                  .shouldNavigateCompleteProfile) {
                                Get.to(() => const CompleteProfileScreen());
                              } else {
                                Get.offAll(() => const MainBottomNavScreen());
                              }
                            } else {
                              Get.snackbar(
                                "OTP verification failed",
                                verifyOtpController.errorMessage,
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
                              // Get.showSnackbar(GetSnackBar(
                              //   title: "OTP verification failed",
                              //   message: verifyOtpController.errorMessage,
                              //   isDismissible: true,
                              //   duration: const Duration(seconds: 2),
                              //   backgroundColor: Colors.red.shade50,
                              // ),
                              // );
                            }
                          }
                        },
                        child: const Text(
                          "Next",
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 24,
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                      children: [
                        const TextSpan(
                          text: "This code will expire in ",
                        ),
                        TextSpan(
                          text: "$countdown s",
                          style: const TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                ),
                TextButton(
                  onPressed: () => resendCode(),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        return countdown == 0
                            ? Color(AppColors.primaryColor.value)
                            : Colors.grey;
                      },
                    ),
                  ),
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                        //color: Colors.grey,
                        ),
                  ),
                ),
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
    _otpTEController.dispose();
  }
}
