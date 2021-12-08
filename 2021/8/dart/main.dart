import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  int howOften = 0;
  int output2 = 0;

  lines.forEach((element) {
    List<String> elements = element.split(" | ");

    List<String> firstHalf = elements.elementAt(0).split(" ");
    firstHalf.sort((a, b) => a.length.compareTo(b.length));

    Map<String, int> mapping = new Map();

    List<String> cache = firstHalf.removeAt(0).split("");
    cache.sort((a, b) => a.compareTo(b));
    String ONE = cache.join();

    cache = firstHalf.removeAt(0).split("");
    cache.sort((a, b) => a.compareTo(b));
    String SEVEN = cache.join();

    cache = firstHalf.removeAt(0).split("");
    cache.sort((a, b) => a.compareTo(b));
    String FOUR = cache.join();

    cache = firstHalf.removeLast().split("");
    cache.sort((a, b) => a.compareTo(b));
    String EIGHT = cache.join();

    mapping.putIfAbsent(ONE, () => 1);
    mapping.putIfAbsent(SEVEN, () => 7);
    mapping.putIfAbsent(FOUR, () => 4);
    mapping.putIfAbsent(EIGHT, () => 8);

    while (firstHalf.isNotEmpty) {
      List<String> cache = firstHalf.removeAt(0).split("");
      cache.sort((a, b) => a.compareTo(b));
      String value = cache.join();

      if (value.length == 5) {
        if (containsLetters(value, ONE)) {
          mapping.putIfAbsent(value, () => 3);
        } else if (difference(value, FOUR) == 3) {
          mapping.putIfAbsent(value, () => 5);
        } else {
          mapping.putIfAbsent(value, () => 2);
        }
      } else {
        if (difference(value, FOUR) == 2) {
          mapping.putIfAbsent(value, () => 9);
        } else if (difference(value, SEVEN) == 3) {
          mapping.putIfAbsent(value, () => 0);
        } else {
          mapping.putIfAbsent(value, () => 6);
        }
      }
    }

    int outputValue = 0;

    elements.elementAt(1).split(" ").forEach((element) {
      outputValue *= 10;
      cache = element.split("");
      cache.sort((a, b) => a.compareTo(b));
      outputValue += mapping[cache.join()]!;
    });

    output2 += outputValue;

    elements.elementAt(1).split(" ").forEach((element) {
      switch (element.length) {
        case 2:
        case 3:
        case 4:
        case 7:
          howOften++;
          break;
        default:
      }
    });
  });

  print("Angabe 1: $howOften");
  print("Angabe 2: $output2");
}

int difference(String string1, String string2) {
  int differenceCounter = 0;

  for (var i = 0; i < string1.length; i++) {
    string2.contains(string1[i]) ? null : differenceCounter++;
  }

  for (var i = 0; i < string2.length; i++) {
    string1.contains(string2[i]) ? null : differenceCounter++;
  }

  return differenceCounter;
}

bool containsLetters(String string1, String string2) {
  for (var letter in string2.split("")) {
    if (!string1.contains(letter)) {
      return false;
    }
  }
  return true;
}
