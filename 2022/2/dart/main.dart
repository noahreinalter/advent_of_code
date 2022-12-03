import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  int score = 0;
  int score2 = 0;
  Map<String, int> lockupTable = {
    "A": 1,
    "B": 2,
    "C": 3,
    "X": 1,
    "Y": 2,
    "Z": 3
  };

  Stream<String> lines = new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter());

  await for (var line in lines) {
    List<String> instructions = line.split(" ");

    if (lockupTable[instructions[0]] == lockupTable[instructions[1]]) {
      score += 3 + (lockupTable[instructions[1]] ?? 0);
    } else if (((lockupTable[instructions[0]] ?? 0) % 3) + 1 ==
        lockupTable[instructions[1]]) {
      score += 6 + (lockupTable[instructions[1]] ?? 0);
    } else {
      score += (lockupTable[instructions[1]] ?? 0);
    }

    if (instructions[1] == "X") {
      score2 += (((lockupTable[instructions[0]] ?? 1) - 1) + 2) % 3 + 1;
    } else if (instructions[1] == "Y") {
      score2 += 3 + (lockupTable[instructions[0]] ?? 0);
    } else {
      score2 += 6 + (((lockupTable[instructions[0]] ?? 1) % 3) + 1);
    }
  }

  print("Aufagbe 1: $score");
  print("Aufgabe 2: $score2");
}
