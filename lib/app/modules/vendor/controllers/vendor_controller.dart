import 'package:dio/dio.dart';
import 'package:echo_flutter/app/constants/agent_ids.dart';
import 'package:echo_flutter/app/constants/backend_url.dart';
import 'package:echo_flutter/app/modules/calling_service/controllers/calling_service_controller.dart';
import 'package:echo_flutter/app/modules/calling_service/views/calling_service_view.dart';
import 'package:echo_flutter/app/modules/home/controllers/models/llm_models.dart';
import 'package:echo_flutter/app/modules/home/controllers/models/places_model.dart';
import 'package:echo_flutter/app/modules/vendor/controllers/models/agent_model.dart';
import 'package:get/get.dart';

class VendorController extends GetxController {
  VendorController({required this.places, required this.textQuery});
  final List<PlacesModel> places;
  final String textQuery;
  final dio = Dio();

  final selectedVendors = <String, String>{}.obs;
  final isLoading = false.obs;

  void toggleSelection(String id, String phoneNumber, bool selected) {
    if (selected) {
      selectedVendors[id] = phoneNumber;
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
      const url = '$backendUrl/bolna_agent/call';
      final response = await dio.post(
        url,
        data: {
          'agent_id': agentId,
          'recipient_phone_number': providerPhoneNumber,
          'user_data': model.toJson(),
        },
      );
      return AgentCallModel(
        message: response.data['message'],
        status: response.data['status'],
        executionId: response.data['execution_id'],
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to call Agent API: $e');
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

    List demoPhoneNumbers = ['+918921787594', '+918078113354'];
    final selectedVendorsWithPhoneNumbers = <String, String>{};
    for (int i = 0; i < selectedVendors.length; i++) {
      selectedVendorsWithPhoneNumbers[selectedVendors.keys.elementAt(i)] =
          demoPhoneNumbers[i];
    }
    final futures = selectedVendorsWithPhoneNumbers.entries.map((vendor) async {
      final vendorId = vendor.key;

      final agentRequestModel = AgentCallRequestModel(
        customerName: 'Abhishek',
        customerPhoneNumber: '+91892187594',
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
        Get.put(CallingServiceController(messages: messages));
      }),
    );
    return messages;
  }
}
