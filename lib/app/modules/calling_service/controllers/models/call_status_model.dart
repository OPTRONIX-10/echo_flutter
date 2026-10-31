import 'package:echo_flutter/app/modules/calling_service/controllers/models/agent_response_model.dart';

class VendorCallStatus {
  final String executionId;
  final String status;
  final AgentResponseModel? agentResponseModel;

  VendorCallStatus({
    required this.executionId,
    required this.status,
    this.agentResponseModel,
  });
}
