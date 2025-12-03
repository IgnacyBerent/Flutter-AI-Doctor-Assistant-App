class TranscriptionHistory {
  final String id;
  final String doctorId;
  final String transcript;

  TranscriptionHistory({
    required this.id,
    required this.doctorId,
    required this.transcript,
  });

  factory TranscriptionHistory.fromJson(Map<String, dynamic> json) {
    return TranscriptionHistory(
      id: json['id'] as String,
      doctorId: json['doctor_id'] as String,
      transcript: json['transcript'] as String,
    );
  }

  String extractHPI() {
    final hpiRegex = RegExp(
      r'\*\*History of Present Illness \(HPI\):\*\*([\s\S]*?)(?=\*\*Past Medical History \(PMH\):|---|##)',
      multiLine: true,
    );
    final match = hpiRegex.firstMatch(transcript);

    if (match != null) {
      String hpiContent = match.group(1)?.trim() ?? '';
      // Clean up markdown noise (e.g., newline characters)
      hpiContent = hpiContent.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();

      // Split into words and take the first 15
      final words = hpiContent
          .split(RegExp(r'\s+'))
          .where((s) => s.isNotEmpty)
          .toList();

      if (words.isEmpty) return 'Details Pending.';

      // Take the first 15 words or fewer, join them, and add ellipsis if truncated
      if (words.length > 15) {
        return '${words.sublist(0, 15).join(' ')}...';
      }
      return words.join(' ');
    }
    return 'HPI content structure not found.';
  }
}
