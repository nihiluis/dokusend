/// Removes common leading whitespace from multi-line strings.
///
/// Example:
/// ```
/// final text = dedent('''
///   Hello
///   World
/// ''');
/// // Result: "Hello\nWorld"
/// ```
String dedent(String text) {
  if (text.isEmpty) return text;

  // Split the text into lines
  final lines = text.split('\n');

  // Find the minimum indentation level (ignoring empty lines)
  int? minIndent;
  for (final line in lines) {
    final trimmedLine = line.trimLeft();
    // Skip empty lines
    if (trimmedLine.isEmpty) continue;

    final indent = line.length - trimmedLine.length;
    minIndent = (minIndent == null || indent < minIndent) ? indent : minIndent;

    // If we find a line with no indentation, we can stop
    if (minIndent == 0) break;
  }

  // If no indentation was found or all lines were empty
  if (minIndent == null || minIndent == 0) return text;

  // Remove the common indentation from each line
  final result = lines.map((line) {
    if (line.isEmpty) return line;
    if (line.length <= minIndent!) return '';
    return line.substring(minIndent!);
  }).join('\n');

  return result;
}
