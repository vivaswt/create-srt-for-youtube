import 'package:create_srt_for_youtube/model/word.dart';

/// A part of a sentence or a sentence it self.
class SentenceSegment {
  final List<Word> words;
  SentenceSegment(this.words);

  int get start => words.first.start;
  int get end => words.last.end;
}

/// Splits a list of [Word] objects into a list of [SentenceSegment]s.
List<SentenceSegment> splitBySentence(List<Word> words) {
  if (words.isEmpty) {
    return [];
  }

  final sentencesAsWords = words.fold<List<List<Word>>>([], (sentences, word) {
    if (sentences.isEmpty || isEndOfSentence(sentences.last.last)) {
      sentences.add([word]);
    } else {
      sentences.last.add(word);
    }
    return sentences;
  });

  return sentencesAsWords.map((wordList) => SentenceSegment(wordList)).toList();
}

/// Returns true if the given [Word] is the end of a sentence.
bool isEndOfSentence(Word word) =>
    word.text.endsWith('.') ||
    word.text.endsWith('?') ||
    word.text.endsWith('!');
