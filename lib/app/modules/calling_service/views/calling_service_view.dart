import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../constants/colour_constant.dart';
import '../controllers/calling_service_controller.dart';
import '../controllers/models/agent_response_model.dart';

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
        child: Obx(() {
          final vendors = controller.selectedVendors.values.toList();
          final messages = controller.messages;
          final statusByExecutionId = {
            for (final entry in controller.callStatuses.entries)
              entry.key: entry.value,
          };

          if (vendors.isEmpty || messages.isEmpty) {
            return const Center(
              child: Text(
                'No calls found',
                style: TextStyle(color: secondaryColor),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vendors.length < messages.length
                ? vendors.length
                : messages.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              final message = messages[index];
              final callStatus = statusByExecutionId[message.executionId];

              return _VendorCallCard(
                vendorName: vendor.name,
                phoneNumber: vendor.contactNumber,
                address: vendor.address,
                status: callStatus?.status ?? message.status,
                response: callStatus?.agentResponseModel,
                onCall: vendor.contactNumber == null
                    ? null
                    : () => controller.callVendor(vendor.contactNumber!),
              );
            },
          );
        }),
      ),
    );
  }
}

class _VendorCallCard extends StatelessWidget {
  const _VendorCallCard({
    required this.vendorName,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.response,
    required this.onCall,
  });

  final String vendorName;
  final String? phoneNumber;
  final String address;
  final String status;
  final AgentResponseModel? response;
  final VoidCallback? onCall;

  bool get isCompleted {
    return _completedStatuses.contains(_normalizeStatus(status));
  }

  @override
  Widget build(BuildContext context) {
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
                    vendorName,
                    style: const TextStyle(
                      color: primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _StatusBadge(status: status),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(icon: Icons.phone, value: phoneNumber ?? 'Unknown'),
            const SizedBox(height: 6),
            _InfoRow(icon: Icons.location_on, value: address),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton.icon(
                onPressed: onCall,
                icon: const Icon(Icons.call),
                label: const Text('Call provider'),
              ),
            ),
            if (isCompleted && response != null) ...[
              const Divider(height: 24),
              _CompletedCallDetails(response: response!),
            ],
          ],
        ),
      ),
    );
  }
}

class _CompletedCallDetails extends StatelessWidget {
  const _CompletedCallDetails({required this.response});

  final AgentResponseModel response;

  @override
  Widget build(BuildContext context) {
    final date = _formatDate(_findExtractedValue(response, 'date'));
    final time = _formatTime(_findExtractedValue(response, 'time'));
    final price = 'Rs ${_findExtractedValue(response, 'price')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _DetailRow(label: 'Date', value: date),
        _DetailRow(label: 'Time', value: time),
        _DetailRow(label: 'Price', value: price),
        if (response.summary.isNotEmpty)
          _ExpandableSection(title: 'Summary', content: response.summary),
        if (response.transcript.isNotEmpty)
          _ExpandableSection(title: 'Transcript', content: response.transcript),
        if (response.recordingUrl != null)
          _ExpandableSection(
            title: 'Recording',
            content: response.recordingUrl!,
            onTap: () => launchUrl(
              Uri.parse(response.recordingUrl!),
              mode: LaunchMode.externalApplication,
            ),
          ),
      ],
    );
  }
}

String _findExtractedValue(AgentResponseModel response, String term) {
  for (final category in response.extractedData.values) {
    for (final entry in category.entries) {
      final name = entry.key.toLowerCase();
      if (name.contains(term)) {
        return entry.value.subjective?.isNotEmpty == true
            ? entry.value.subjective!
            : entry.value.objective ?? 'Not provided';
      }
    }
  }
  return 'Not provided';
}

String _formatDate(String value) {
  final date = DateTime.tryParse(value);
  if (date == null) {
    return value;
  }

  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _formatTime(String value) {
  final match = RegExp(
    r'^(\d{1,2}):(\d{2})(?::\d{2})?$',
  ).firstMatch(value.trim());
  if (match == null) {
    return value;
  }

  final hour = int.tryParse(match.group(1)!);
  final minute = int.tryParse(match.group(2)!);
  if (hour == null || minute == null || hour > 23 || minute > 59) {
    return value;
  }

  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
}

class _ExpandableSection extends StatelessWidget {
  const _ExpandableSection({
    required this.title,
    required this.content,
    this.onTap,
  });

  final String title;
  final String content;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: tertiaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: onTap == null
          ? null
          : const Icon(Icons.play_circle_outline, color: primaryColor),
      onExpansionChanged: onTap == null
          ? null
          : (expanded) {
              if (expanded) {
                onTap!();
              }
            },
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(content, style: const TextStyle(color: primaryColor)),
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: primaryColor),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: tertiaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(value, style: const TextStyle(color: primaryColor)),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = _normalizeStatus(status);
    final color = _completedStatuses.contains(normalizedStatus)
        ? tertiaryColor
        : normalizedStatus == 'in-progress' || normalizedStatus == 'talking'
        ? Colors.green
        : Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

String _normalizeStatus(String status) {
  return status.trim().toLowerCase().replaceAll('_', '-').replaceAll(' ', '-');
}

const _completedStatuses = {
  'completed',
  'complete',
  'failed',
  'busy',
  'no-answer',
  'noanswer',
};
