import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:echo_flutter/app/constants/agent_ids.dart';
import 'package:echo_flutter/app/constants/backend_url.dart';
import 'package:echo_flutter/app/modules/calling_service/controllers/calling_service_controller.dart';
import 'package:echo_flutter/app/modules/calling_service/views/calling_service_view.dart';
import 'package:echo_flutter/app/modules/home/controllers/models/places_model.dart';
import 'package:echo_flutter/app/modules/vendor/controllers/models/agent_model.dart';
import 'package:echo_flutter/app/modules/vendor/controllers/models/llm_models.dart';
import 'package:get/get.dart';

class VendorController extends GetxController {
  VendorController({required this.places, required this.textQuery});
  final List<PlacesModel> places;
  final String textQuery;
  final dio = Dio();

  final selectedVendors = <String, PlacesModel>{}.obs;
  final isLoading = false.obs;

  void toggleSelection(String id, PlacesModel model, bool selected) {
    if (selected) {
      selectedVendors[id] = model;
    } else {
      selectedVendors.remove(id);
    }
  }

  Future<LlmResponseModel> callLlmApi({required String userMessage}) async {
    try {
      const url = '$backendUrl/llm/response';
      final response = await dio.get(
        url,
        queryParameters: {'message': userMessage},
      );
      return LlmResponseModel(
        serviceDescription: response.data['service_description'],
        serviceCategory: response.data['service_category'],
      );
    } catch (e) {
      log('Error calling LLM API: $e', name: 'llm api');
      Get.snackbar('Error', 'Failed to call LLM API: $e');
      rethrow;
    }
  }

  Future<AgentCallModel> callAgentApi({
    required AgentCallRequestModel model,
    required String agentId,
    required String providerPhoneNumber,
  }) async {
    try {
      isLoading.value = true;
      const url = '$backendUrl/bolna_agent/call';
      log('Calling Agent API with model: ${model.toJson()}', name: 'agent api');
      final response = await dio.post(
        url,
        queryParameters: {
          'agent_id': agentId,
          'recipient_phone_number': providerPhoneNumber,
        },
        data: model.toJson(),
      );
      isLoading.value = false;
      return AgentCallModel(
        message: response.data['message'],
        status: response.data['status'],
        executionId: response.data['execution_id'],
      );
    } on DioException catch (e) {
      isLoading.value = false;
      // log(
      //   'Error calling Agent API: ${e.response?.statusCode} '
      //   '${e.response?.data ?? e.message}',
      //   name: 'agent api',
      // );
      // Get.snackbar(
      //   'Agent API error',
      //   e.response?.data?.toString() ?? e.message ?? 'Request failed',
      // );

      Get.snackbar("error", e.message ?? 'Error initating call');
      rethrow;
    }
  }

  Future<List<AgentCallModel>> callSelectedVendor() async {
    if (selectedVendors.isEmpty) {
      Get.snackbar('No vendor selected', 'Select a vendor before calling.');
      return [];
    }
    isLoading.value = true;
    final response = await callLlmApi(userMessage: textQuery);

    List demoPhoneNumbers = ['+918921787594', '+918921787594'];
    final selectedVendorsWithPhoneNumbers = <String, String>{};
    for (int i = 0; i < selectedVendors.length; i++) {
      selectedVendorsWithPhoneNumbers[selectedVendors.keys.elementAt(i)] =
          demoPhoneNumbers[i];
    }

    final futures = selectedVendorsWithPhoneNumbers.entries.map((vendor) async {
      final vendorId = vendor.key;

      final agentRequestModel = AgentCallRequestModel(
        customerName: 'Abhishek',
        customerPhoneNumber: '+918921787594',
        customerLocation: 'Venomeny',
        serviceType: response.serviceCategory,
        serviceDescription: response.serviceDescription,
        vendorName: places.firstWhere((place) => place.id == vendorId).name,
      );

      final agentResponse = await callAgentApi(
        model: agentRequestModel,
        agentId: echoAgentId,
        providerPhoneNumber: vendor.value,
      );

      return agentResponse;
    });

    final messages = await Future.wait(futures);

    isLoading.value = false;
    Get.to(
      () => CallingServiceView(),
      binding: BindingsBuilder(() {
        Get.put(
          CallingServiceController(
            messages: messages,
            selectedVendors: selectedVendors,
          ),
        );
      }),
    );
    return messages;
  }
}
