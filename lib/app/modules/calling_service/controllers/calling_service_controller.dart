import 'dart:convert';
import 'dart:developer';
import 'package:echo_flutter/app/modules/calling_service/controllers/models/agent_response_model.dart';
import 'package:echo_flutter/app/modules/calling_service/controllers/models/call_status_model.dart';
import 'package:echo_flutter/app/modules/home/controllers/models/places_model.dart';
import 'package:echo_flutter/app/modules/vendor/controllers/models/agent_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CallingServiceController extends GetxController {
  CallingServiceController({
    required this.messages,
    required this.selectedVendors,
  });
  final List<AgentCallModel> messages;
  final Map<String, PlacesModel> selectedVendors;

  final Map<String, WebSocketChannel> channels = {};
  RxMap<String, VendorCallStatus> callStatuses =
      <String, VendorCallStatus>{}.obs;

  @override
  void onInit() {
    super.onInit();
    for (final message in messages) {
      callStatuses[message.executionId] = VendorCallStatus(
        executionId: message.executionId,
        status: message.status,
      );
    }
    connectMultiple(messages.map((message) => message.executionId).toList());
  }

  Future<void> connectWebSocketChannel({required String executionId}) async {
    try {
      if (channels.containsKey(executionId)) {
        return;
      }
      final websocketUri = Uri.parse(
        'wss://echo-backend-q97a.onrender.com/websocket/$executionId',
      );
      final channel = WebSocketChannel.connect(websocketUri);
      channels[executionId] = channel;
      channel.stream.listen(
        (message) {
          final data = jsonDecode(message);
          log(
            'Received message for executionId $executionId: $data',
            name: 'websocket',
          );
          AgentResponseModel? agentResponse;
          if (data['data'] != null) {
            agentResponse = AgentResponseModel.fromJson(
              Map<String, dynamic>.from(data['data']),
            );
          }
          callStatuses[executionId] = VendorCallStatus(
            executionId: executionId,
            status: data['status'],
            agentResponseModel: agentResponse,
          );
        },
        onError: (error) {
          log('WebSocket error: $error', name: 'websocket');
          Get.snackbar('WebSocket Error', 'An error occurred: $error');
        },
        onDone: () {
          log('WebSocket connection closed', name: 'websocket');
          channels.remove(executionId);
        },
      );
    } catch (e) {
      log('Error connecting to WebSocket: $e', name: 'websocket');
      Get.snackbar('Error', 'Failed to connect to WebSocket: $e');
      rethrow;
    }
  }

  void connectMultiple(List<String> executionIds) {
    for (final id in executionIds) {
      connectWebSocketChannel(executionId: id);
    }
  }

  void disconnect(String executionId) {
    channels[executionId]?.sink.close();
    channels.remove(executionId);
  }

  void disconnectAll() {
    for (final channel in channels.values) {
      channel.sink.close();
    }

    channels.clear();
  }

  Future<void> callVendor(String phoneNumber) async {
    final phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );

    if (!await launchUrl(phoneUri)) {
      Get.snackbar(
        'Unable to call vendor',
        'No phone application is available on this device.',
      );
    }
  }

  @override
  void onClose() {
    disconnectAll();
    super.onClose();
  }
}
