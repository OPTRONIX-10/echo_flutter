import 'dart:async';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeController extends GetxController {

  final SpeechToText _speechToText = SpeechToText();
  bool _isSpeechAvailable = false;
  final isListening = false.obs;
  final transcription = 'Tap the microphone to start recording'.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    _isSpeechAvailable = await _speechToText.initialize(
      onStatus: (status) {
        Get.snackbar('Speech', status);
        if (status == 'done') {
          stopListening();
        }
      },
      onError: (error) {
        Get.snackbar('Speech error', error.errorMsg);
        stopListening();
      },
    );
  }

  void startListening() async {
    if (_isSpeechAvailable) {
      await _speechToText.listen(
        onResult: (result) {
          transcription.value = result.recognizedWords;
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
      isListening.value = true;
    } else {
      Get.snackbar('Error', 'Speech recognition not available');
    }
  }

  void stopListening() async {
    await _speechToText.stop();
    isListening.value = false;
    transcription.value = 'Tap the microphone to start recording';
  }

  @override
  void onClose() async {
    // _cleanupPipeline();
    // _audioRecorder.dispose();
    await _speechToText.stop();
    isListening.value = false;
    transcription.value = 'Tap the microphone to start recording';

    super.onClose();
  }
}
