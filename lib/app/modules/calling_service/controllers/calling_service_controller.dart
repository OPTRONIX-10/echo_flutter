import 'package:get/get.dart';

enum CallStatus { dialing, talking, complete }

class CallSession {
  CallSession({
    required this.title,
    required this.status,
    required this.agentTranscription,
    required this.vendorTranscription,
  });

  final String title;
  final CallStatus status;
  final String agentTranscription;
  final String vendorTranscription;
}

class CallingServiceController extends GetxController {
  final callSessions = <CallSession>[
    CallSession(
      title: 'Sharma Electricals',
      status: CallStatus.talking,
      agentTranscription:
          'Hello, I am calling from Echo. I would like to discuss your latest order.',
      vendorTranscription:
          'Hello. Sure, please tell me what information you need.',
    ),
    CallSession(
      title: 'Patel Hardware',
      status: CallStatus.dialing,
      agentTranscription: 'Dialing the vendor...',
      vendorTranscription: 'Waiting for the vendor to answer.',
    ),
    CallSession(
      title: 'Kumar Supplies',
      status: CallStatus.complete,
      agentTranscription: 'Thank you for your time. Goodbye.',
      vendorTranscription: 'Thank you. Goodbye.',
    ),
  ].obs;

  void bargeIn(int index) {
    final session = callSessions[index];
    if (session.status != CallStatus.dialing) {
      return;
    }

    callSessions[index] = CallSession(
      title: session.title,
      status: CallStatus.talking,
      agentTranscription: session.agentTranscription,
      vendorTranscription: session.vendorTranscription,
    );
  }

  void hangUp(int index) {
    final session = callSessions[index];
    if (session.status == CallStatus.complete) {
      return;
    }

    callSessions[index] = CallSession(
      title: session.title,
      status: CallStatus.complete,
      agentTranscription: session.agentTranscription,
      vendorTranscription: session.vendorTranscription,
    );
  }
}
