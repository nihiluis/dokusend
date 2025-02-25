/// Generates a markdown frontmatter header from a map of key-value pairs.
/// 
/// The frontmatter is formatted as YAML between triple-dash delimiters.
/// Example output:
/// ```
/// ---
/// title: My Document
/// date: 2023-04-15
/// tags: [markdown, documentation]
/// ---
/// ```
String createMarkdownHeader(Map<String, dynamic> metadata) {
  if (metadata.isEmpty) {
    return '';
  }

  final StringBuffer buffer = StringBuffer();
  buffer.writeln('---');
  
  metadata.forEach((key, value) {
    if (value is List) {
      // Handle lists with YAML array syntax
      buffer.write('$key: [');
      buffer.write(value.map((item) => item.toString()).join(', '));
      buffer.writeln(']');
    } else {
      // Handle simple key-value pairs
      buffer.writeln('$key: $value');
    }
  });
  
  buffer.writeln('---');
  buffer.writeln();
  
  return buffer.toString();
}
