import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  int horizontalPosition = 0;
  int depth = 0;

  int depth2 = 0;
  int aim = 0;

  Stream<String> lines = new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter());

  await for (var line in lines) {
    List<String> splitLine = line.split(" ");
    int parsedInt = int.parse(splitLine[1]);

    switch (splitLine[0]) {
      case "forward":
        horizontalPosition += parsedInt;
        depth2 += aim * parsedInt;
        break;
      case "up":
        depth -= parsedInt;
        aim -= parsedInt;
        break;
      case "down":
        depth += parsedInt;
        aim += parsedInt;
        break;
      default:
    }
  }

  print("Horizontal position: $horizontalPosition");
  print("Depth: $depth");
  print("Aufgabe 1: " + (horizontalPosition * depth).toString());

  print("Depth2: $depth2");
  print("Aim: $aim");
  print("Aufgabe 2: " + (horizontalPosition * depth2).toString());
}
