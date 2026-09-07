import 'package:intl/intl.dart';
import 'package:src_kstu_app/models/announcement.dart';

/// Best-effort creation timestamp for an announcement. Tries the raw
/// `created_at` (ISO 8601) first, then falls back to parsing the human
/// string `created_at_formatted` (e.g. "Saturday, 31st May 2026").
DateTime? announcementDate(Announcement a) {
  final iso = DateTime.tryParse(a.createdAt);
  if (iso != null) return iso;
  return _parseFormattedDate(a.createdAtFormatted);
}

DateTime? _parseFormattedDate(String s) {
  if (s.isEmpty) return null;
  // Drop the leading weekday if present: "Saturday, 31st May 2026" -> "31st May 2026"
  final datePart = s.contains(', ') ? s.split(', ').last : s;
  // Strip ordinal suffixes: "31st" -> "31"
  final cleaned = datePart
      .replaceAllMapped(
        RegExp(r'(\d+)(st|nd|rd|th)', caseSensitive: false),
        (m) => m.group(1)!,
      )
      .trim();
  for (final pattern in const ['d MMMM yyyy', 'd MMM yyyy', 'MMMM d yyyy']) {
    try {
      return DateFormat(pattern).parseLoose(cleaned);
    } catch (_) {}
  }
  return null;
}

/// Returns a copy of [items] ordered newest-first by creation date/time.
/// Falls back to the (auto-incrementing) id when a timestamp can't be parsed.
List<Announcement> sortAnnouncementsByNewest(List<Announcement> items) {
  final sorted = [...items];
  sorted.sort((a, b) {
    final da = announcementDate(a);
    final db = announcementDate(b);
    if (da != null && db != null) {
      final cmp = db.compareTo(da);
      return cmp != 0 ? cmp : b.id.compareTo(a.id);
    }
    if (da == null && db != null) return 1;
    if (da != null && db == null) return -1;
    return b.id.compareTo(a.id);
  });
  return sorted;
}
