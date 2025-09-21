/// Represents a single transcribed word with its timing information.
class Word {
  final String text;
  final int start;
  final int end;

  Word({required this.text, required this.start, required this.end});
}
