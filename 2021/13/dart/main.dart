import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  Map<int, Map<int, String>> paper = new Map();
  List<List<int>> folds = new List.empty(growable: true);

  lines.forEach((element) {
    if (element.startsWith("fold")) {
      int rowOrColumn;
      if (element.contains("x")) {
        rowOrColumn = 0;
      } else {
        rowOrColumn = 1;
      }

      folds.add([rowOrColumn, int.parse(element.split("=").last)]);
    } else if (element != "") {
      List<int> coordinates =
          element.split(",").map((e) => int.parse(e)).toList();
      int x = coordinates.elementAt(0);
      int y = coordinates.elementAt(1);
      paper.putIfAbsent(x, () => new Map());
      paper[x]?.putIfAbsent(y, () => "#");
    }
  });

  paper = fold(paper, folds.first);
  folds.removeAt(0);
  int dots = countDots(paper);

  for (var foldPosition in folds) {
    paper = fold(paper, foldPosition);
  }

  print("Angabe 1: $dots");

  List<List<String>> printList =
      new List.generate(6, (index) => new List.generate(40, (index) => " "));

  for (var x in paper.keys) {
    for (var y in paper[x]!.keys) {
      printList[y][x] = "#";
    }
  }

  printList.forEach((element) {
    print(element.join());
  });
}

Map<int, Map<int, String>> fold(
    Map<int, Map<int, String>> input, List<int> foldPosition) {
  Map<int, Map<int, String>> newPaper = new Map();

  if (foldPosition.elementAt(0) == 0) {
    for (var x
        in input.keys.where((element) => element < foldPosition.elementAt(1))) {
      newPaper.putIfAbsent(x, () => new Map.from(input[x]!));
    }
    for (var x
        in input.keys.where((element) => element > foldPosition.elementAt(1))) {
      int newX = 2 * foldPosition.elementAt(1) - x;
      newPaper.putIfAbsent(newX, () => new Map());
      for (var y in input[x]!.keys) {
        newPaper[newX]!.putIfAbsent(y, () => input[x]![y]!);
      }
    }
  } else if (foldPosition.elementAt(0) == 1) {
    for (var x in input.keys) {
      Map<int, String> newMap = new Map();

      for (var y in input[x]!.keys) {
        if (y < foldPosition.elementAt(1)) {
          newMap.putIfAbsent(y, () => input[x]![y]!);
        } else if (y > foldPosition.elementAt(1)) {
          int newY = 2 * foldPosition.elementAt(1) - y;
          newMap.putIfAbsent(newY, () => input[x]![y]!);
        }
      }

      if (newMap.isNotEmpty) {
        newPaper.putIfAbsent(x, () => newMap);
      }
    }
  }

  return newPaper;
}

int countDots(Map<int, Map<int, String>> input) {
  int dots = 0;

  input.forEach((x, value) {
    value.forEach((y, value) {
      if (value == "#") {
        dots += 1;
      }
    });
  });

  return dots;
}
