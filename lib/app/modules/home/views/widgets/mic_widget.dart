import 'package:avatar_glow/avatar_glow.dart';
import 'package:echo_flutter/app/constants/colour_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/home_controller.dart';

class MicWidget extends GetView<HomeController> {
  const MicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AvatarGlow(
            glowColor: tertiaryColor,
            glowCount: 3,
            glowRadiusFactor: 0.2,
            child: Container(
              width: 150,
              height: 150,
              decoration: const BoxDecoration(
                color: neutralColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: IconButton(
                iconSize: 72,
                icon: Icon(
                  controller.isListening.value ? Icons.stop_circle : Icons.mic,
                  color: secondaryColor,
                ),
                onPressed: controller.isListening.value
                    ? controller.stopListening
                    : controller.startListening,
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
          Lottie.asset(
            'assets/voice_lottie.json',
            width: double.infinity,
            height: 200,
            repeat: true,
            animate: controller.isListening.value,
          ),
        ],
      ),
    );
  }
}
