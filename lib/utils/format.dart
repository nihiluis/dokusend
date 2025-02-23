class FormatUtils {
  static String formatDate(DateTime date) {
    return '${_padZero(date.month)}/${_padZero(date.day)}/${date.year}';
  }

  static String formatDateTime(DateTime date) {
    return '${formatDate(date)} ${_padZero(date.hour)}:${_padZero(date.minute)}';
  }

  // Helper method to pad single digits with zero
  static String _padZero(int number) {
    return number.toString().padLeft(2, '0');
  }
}
