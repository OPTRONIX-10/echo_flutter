
class AgentResponseModel {
  const AgentResponseModel({
    required this.id,
    required this.agentId,
    required this.status,
    required this.transcript,
    required this.summary,
    required this.extractedData,
    required this.recordingUrl,
  });

  final String id;
  final String agentId;
  final String status;
  final String transcript;
  final String summary;
  final Map<String, Map<String, ExtractedDataItem>> extractedData;
  final String? recordingUrl;

  factory AgentResponseModel.fromJson(Map<String, dynamic> json) {
    final rawExtractedData = json['extracted_data'] as Map<String, dynamic>?;

    return AgentResponseModel(
      id: json['id'] as String,
      agentId: json['agent_id'] as String,
      status: json['status'] as String,
      transcript: json['transcript'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      extractedData: rawExtractedData?.map(
            (category, values) => MapEntry(
              category,
              (values as Map<String, dynamic>).map(
                (name, value) => MapEntry(
                  name,
                  ExtractedDataItem.fromJson(
                    value as Map<String, dynamic>,
                  ),
                ),
              ),
            ),
          ) ??
          {},
      recordingUrl: json['recording_url'] as String?,
    );
  }
}

class TranscriptItem {
  const TranscriptItem({
    required this.role,
    required this.content,
  });

  final String role;
  final String content;

  factory TranscriptItem.fromJson(Map<String, dynamic> json) {
    return TranscriptItem(
      role: json['role'] as String,
      content: json['content'] as String,
    );
  }
}

class ExtractedDataItem {
  const ExtractedDataItem({
    this.objective,
    this.subjective,
    this.confidence,
    this.confidenceLabel,
    this.validation,
    this.reasoningObjective,
    this.reasoningSubjective,
  });

  final String? objective;
  final String? subjective;
  final double? confidence;
  final String? confidenceLabel;
  final ExtractedDataValidation? validation;
  final String? reasoningObjective;
  final String? reasoningSubjective;

  factory ExtractedDataItem.fromJson(Map<String, dynamic> json) {
    return ExtractedDataItem(
      objective: json['objective']?.toString(),
      subjective: json['subjective']?.toString(),
      confidence: (json['confidence'] as num?)?.toDouble(),
      confidenceLabel: json['confidence_label'] as String?,
      validation: json['validation'] is Map<String, dynamic>
          ? ExtractedDataValidation.fromJson(
              json['validation'] as Map<String, dynamic>,
            )
          : null,
      reasoningObjective: json['reasoning_objective']?.toString(),
      reasoningSubjective: json['reasoning_subjective']?.toString(),
    );
  }
}

class ExtractedDataValidation {
  const ExtractedDataValidation({
    this.pattern,
    this.isValid,
    this.expectedType,
  });

  final String? pattern;
  final bool? isValid;
  final String? expectedType;

  factory ExtractedDataValidation.fromJson(Map<String, dynamic> json) {
    return ExtractedDataValidation(
      pattern: json['pattern'] as String?,
      isValid: json['is_valid'] as bool?,
      expectedType: json['expected_type'] as String?,
    );
  }
}
