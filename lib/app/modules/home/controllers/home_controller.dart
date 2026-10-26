import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {
  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeechAvailable = false;
  final isListening = false.obs;
  final textController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    handleLocationPermission();
    _initializeSpeech();
  }

  Future handleLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar(
          'Location permissions are denied',
          'Please allow location permissions to use this feature.',
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      Get.snackbar(
        'Location permissions are permanently denied',
        'We cannot request permissions.',
      );
      return;
    }
  }

  Future<Position> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current position: $e');
      rethrow;
    }
  }

  Future<void> _initializeSpeech() async {
    _isSpeechAvailable = await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'listening') {
          isListening.value = true;
        } else if (status == 'done' || status == 'notListening') {
          // The plugin has already ended this session. Calling stop() here
          // starts another platform stop request and can end a new session.
          isListening.value = false;
        }
      },
      onError: (error) {
        Get.snackbar('Speech error', error.errorMsg);
        isListening.value = false;
      },
    );
  }

  void startListening() async {
    if (_isSpeechAvailable) {
      isListening.value = true;
      try {
        await _speechToText.listen(
          onResult: (result) {
            textController.text = result.recognizedWords;
          },
          listenOptions: SpeechListenOptions(
            pauseFor: const Duration(seconds: 10),
            listenFor: const Duration(seconds: 60),
            listenMode: ListenMode.dictation,
            partialResults: true,
            onDevice: false,
            localeId: 'en_IN',
          ),
        );
      } on Exception catch (error) {
        isListening.value = false;
        Get.snackbar('Speech error', error.toString());
      }
    } else {
      Get.snackbar('Error', 'Speech recognition not available');
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
  }

  @override
  void onClose() async {
    // _cleanupPipeline();
    // _audioRecorder.dispose();
    await _speechToText.stop();
    isListening.value = false;
    textController.dispose();
    super.onClose();
  }
}
