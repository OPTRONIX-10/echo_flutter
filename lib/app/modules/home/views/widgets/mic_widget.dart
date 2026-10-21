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
    return Obx(
      () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 50,
        children: [
          Lottie.asset(
            'assets/voice_lottie.json',
            width: 200,
            height: 200,
            repeat: true,
            animate: controller.isListening.value,
          ),
          Text(controller.transcription.value, textAlign: TextAlign.center),
          AvatarGlow(
            glowColor: tertiaryColor,
            glowCount: 3,
            glowRadiusFactor: 0.2,
            child: Container(
              decoration: const BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: IconButton(
                iconSize: 72,
                icon: Icon(
                  controller.isListening.value ? Icons.stop_circle : Icons.mic,
                  color: primaryColor,
                ),
                onPressed: controller.isListening.value
                    ? controller.stopListening
                    : controller.startListening,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
