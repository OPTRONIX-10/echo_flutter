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
        children: [
          Lottie.asset(
            'assets/voice_lottie.json',
            width: double.infinity,
            height: 200,
            repeat: true,
            animate: controller.isListening.value,
          ),
          AvatarGlow(
            glowColor: tertiaryColor,
            glowCount: 3,
            glowRadiusFactor: 0.5,
            child: Container(
              width: 150,
              height: 150,
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
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: neutralColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                controller.transcription.value,
                textAlign: TextAlign.center,
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 18, color: secondaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
