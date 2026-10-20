import 'dart:async';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeController extends GetxController {
  final AudioRecorder _audioRecorder = AudioRecorder();
  WebSocketChannel? _channel;
  StreamSubscription<Uint8List>? _audioSubscription;

  final isStreaming = false.obs;
  final liveTranscription = 'Tap mic to speak...'.obs;

  Future<void> startGroqPipeline() async {
    if (isStreaming.value) {
      return;
    }

    if (!await _audioRecorder.hasPermission()) {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        _showError('Microphone permission denied');
        return;
      }
    }

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://YOUR_BACKEND_IP:8000/ws/stream'),
      );
      _channel!.stream.listen(
        (message) => liveTranscription.value = message.toString(),
        onError: (Object error, StackTrace stackTrace) {
          _showError('Unable to receive transcription: $error');
          stopGroqPipeline();
        },
      );

      final audioStream = await _audioRecorder.startStream(
        const RecordConfig(
          encoder: AudioEncoder.pcm16bits,
          sampleRate: 16000,
          numChannels: 1,
        ),
      );

      isStreaming.value = true;
      liveTranscription.value = 'Listening...';
      _audioSubscription = audioStream.listen((Uint8List rawChunk) {
        if (isStreaming.value && _channel != null) {
          _channel!.sink.add(rawChunk);
        }
      });
    } on Object catch (error, stackTrace) {
      _showError('Unable to start listening: $error');
      await _cleanupPipeline();
      Get.log('$error\n$stackTrace');
    }
  }

  Future<void> stopGroqPipeline() async {
    if (!isStreaming.value && _audioSubscription == null && _channel == null) {
      return;
    }

    isStreaming.value = false;
    await _cleanupPipeline();
  }

  Future<void> _cleanupPipeline() async {
    await _audioSubscription?.cancel();
    _audioSubscription = null;
    await _audioRecorder.stop();
    await _channel?.sink.close();
    _channel = null;
  }

  void _showError(String message) {
    liveTranscription.value = message;
    Get.snackbar('Voice input error', message);
  }

  @override
  void onClose() {
    _cleanupPipeline();
    _audioRecorder.dispose();
    super.onClose();
  }
}
