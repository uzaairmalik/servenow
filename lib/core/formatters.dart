/// Small, dependency-free formatters. Keeping these out of widgets means
/// prices render identically on every screen (and in tests).
String formatPKR(num amount) {
  // 12500 -> "Rs 12,500" — hand-rolled so we need no intl dependency.
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
    buffer.write(digits[i]);
  }
  return 'Rs $buffer';
}

/// 90 -> "1h 30m", 45 -> "45m".
String formatDuration(int minutes) {
  if (minutes < 60) return '${minutes}m';
  final h = minutes ~/ 60;
  final m = minutes % 60;
  return m == 0 ? '${h}h' : '${h}h ${m}m';
}
