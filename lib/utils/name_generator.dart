import 'dart:math';

class NameGenerator {
  final consonants = ['b', 'c', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'm', 'n', 'p', 'q', 'r', 's', 't', 'v', 'w', 'x', 'z'];
  final vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
  final Random random = Random();

  String generateDefaultName() {
    String generatedName = '';
    int wordCount = random.nextInt(2) + 1;

    for (var i = 0; i < wordCount; i++) {
      int syllableCount = random.nextInt(5) + 3;
      bool startWithVowel = random.nextBool();
      String word = '';
      
      for (var j = 0; j < syllableCount; j++) {
        if (startWithVowel) {
          word += vowels[random.nextInt(vowels.length)];
          startWithVowel = false;
        } 
        else {
          word += consonants[random.nextInt(consonants.length)];
          startWithVowel = true;
        }
      }

      word = word[0].toUpperCase() + word.substring(1);

      if (i > 0) {
        generatedName += ' ';
      }

      generatedName += word;
    }

    return generatedName;
  }
}