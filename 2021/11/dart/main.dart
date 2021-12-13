import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  List<List<int>> grid = new List.generate(
      lines.length,
      (i) => new List.generate(
          lines.elementAt(i).length, (j) => int.parse(lines.elementAt(i)[j])));

  int numberFlashes = 0;
  int allFlashFirstTime = 0;
  int i = 0;
  while (true) {
    grid = grid.map((e) => e.map((e) => e + 1).toList()).toList();
    int newNumberFlashes = probagateFlash(grid);

    if (i < 100) {
      numberFlashes += newNumberFlashes;
    }
    if (grid
        .where((element) => element.where((element) => element != 0).isNotEmpty)
        .isEmpty) {
      allFlashFirstTime = i + 1;
      break;
    }
    i++;
  }

  print("Angabe 1: $numberFlashes");
  print("Angabe 2: $allFlashFirstTime");
}

int probagateFlash(List<List<int>> input) {
  int numberOfFlashes = 0;

  while (input.where((element) => element.contains(10)).isNotEmpty) {
    for (var x = 0; x < input.length; x++) {
      for (var y = 0; y < input.elementAt(x).length; y++) {
        if (input.elementAt(x).elementAt(y) == 10) {
          for (var i = -1; i <= 1; i++) {
            for (var j = -1; j <= 1; j++) {
              addOne(input, x + i, y + j);
            }
            input[x][y] = 11;
          }
        }
      }
    }
  }

  for (var x = 0; x < input.length; x++) {
    for (var y = 0; y < input.elementAt(x).length; y++) {
      if (input.elementAt(x).elementAt(y) == 11) {
        input[x][y] = 0;
        numberOfFlashes++;
      }
    }
  }

  return numberOfFlashes;
}

void addOne(List<List<int>> grid, int x, int y) {
  if (x < 0 || x >= grid.length) {
    return;
  }

  if (y < 0 || y >= grid.elementAt(x).length) {
    return;
  }
  int value = grid.elementAt(x).elementAt(y);
  if (value >= 10) {
    return;
  } else {
    grid[x][y] += 1;
  }
}
