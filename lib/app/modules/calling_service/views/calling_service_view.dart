import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/colour_constant.dart';
import '../controllers/calling_service_controller.dart';

class CallingServiceView extends GetView<CallingServiceController> {
  const CallingServiceView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Calling Service',
          style: TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: neutralColor,
      ),
      body: SafeArea(
        child: Obx(
          () => ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.callSessions.length,
            itemBuilder: (context, index) {
              final session = controller.callSessions[index];
              final isComplete = session.status == CallStatus.complete;

              return Card(
                margin: const EdgeInsets.only(bottom: 14),
                color: secondaryColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.title,
                              style: const TextStyle(
                                color: primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _StatusBadge(status: session.status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Agent transcription',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.agentTranscription,
                        style: const TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Vendor transcription',
                        style: TextStyle(
                          color: tertiaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        session.vendorTranscription,
                        style: const TextStyle(color: primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: session.status == CallStatus.dialing
                                  ? () => controller.bargeIn(index)
                                  : null,
                              icon: const Icon(Icons.record_voice_over),
                              label: const Text('Barge in'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: isComplete
                                  ? null
                                  : () => controller.hangUp(index),
                              icon: const Icon(Icons.call_end),
                              label: const Text('Hang up'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final CallStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      CallStatus.dialing => ('Dialing', Colors.orange),
      CallStatus.talking => ('Talking', Colors.green),
      CallStatus.complete => ('Complete', tertiaryColor),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
