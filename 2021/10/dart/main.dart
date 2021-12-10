import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  int errorPoints = 0;
  List<int> correctionPointsList = new List.empty(growable: true);

  lines.forEach((element) {
    List<String> stack = new List.empty(growable: true);
    List<String> chars = element.split("");
    bool isErrorLine = false;
    for (var element in chars) {
      if (element == "(" ||
          element == "[" ||
          element == "{" ||
          element == "<") {
        stack.add(element);
      } else if (element == ")") {
        if (stack.last == "(") {
          stack.removeLast();
        } else {
          errorPoints += 3;
          isErrorLine = true;
          break;
        }
      } else if (element == "]") {
        if (stack.last == "[") {
          stack.removeLast();
        } else {
          errorPoints += 57;
          isErrorLine = true;
          break;
        }
      } else if (element == "}") {
        if (stack.last == "{") {
          stack.removeLast();
        } else {
          errorPoints += 1197;
          isErrorLine = true;
          break;
        }
      } else if (element == ">") {
        if (stack.last == "<") {
          stack.removeLast();
        } else {
          errorPoints += 25137;
          isErrorLine = true;
          break;
        }
      }
    }

    if (!isErrorLine) {
      int correctionPoints = 0;
      for (var item in stack.reversed) {
        correctionPoints *= 5;

        if (item == "(") {
          correctionPoints += 1;
        } else if (item == "[") {
          correctionPoints += 2;
        } else if (item == "{") {
          correctionPoints += 3;
        } else if (item == "<") {
          correctionPoints += 4;
        }
      }
      correctionPointsList.add(correctionPoints);
    }
  });

  correctionPointsList.sort();
  int correctionPoints =
      correctionPointsList.elementAt(correctionPointsList.length ~/ 2);

  print("Angabe 1: $errorPoints");
  print("Angabe 2: $correctionPoints");
}
