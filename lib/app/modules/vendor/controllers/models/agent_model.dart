class AgentCallModel {
  final String message;
  final String status;
  final String executionId;

  AgentCallModel({
    required this.message,
    required this.status,
    required this.executionId,
  });
}

class AgentCallRequestModel {
  final String customerName;
  final String customerPhoneNumber;
  final String customerLocation;
  final String serviceType;
  final String serviceDescription;
  final String vendorName;

  AgentCallRequestModel({
    required this.customerName,
    required this.customerPhoneNumber,
    required this.customerLocation,
    required this.serviceType,
    required this.serviceDescription,
    required this.vendorName,
  });

  Map<String, dynamic> toJson() {
    return {
      'customer_name': customerName,
      'customer_phone_number': customerPhoneNumber,
      'customer_location': customerLocation,
      'service_type': serviceType,
      'service_description': serviceDescription,
      'provider_bussiness_name': vendorName,
    };
  }
}
