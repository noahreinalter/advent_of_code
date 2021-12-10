import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  HeightMap heightMap = new HeightMap(lines);

  Map<int, Map<int, int>> lowpointMap = new Map();

  int risklevel = 0;

  for (var i = 0; i < lines.length; i++) {
    for (var j = 0; j < lines.elementAt(i).length; j++) {
      bool lowest = true;
      int height = int.parse(lines.elementAt(i)[j]);

      if (i != 0) {
        lowest = int.parse(lines.elementAt(i - 1)[j]) > height ? lowest : false;
      }

      if (i != lines.length - 1) {
        lowest = int.parse(lines.elementAt(i + 1)[j]) > height ? lowest : false;
      }

      if (j != 0) {
        lowest = int.parse(lines.elementAt(i)[j - 1]) > height ? lowest : false;
      }

      if (j != lines.elementAt(i).length - 1) {
        lowest = int.parse(lines.elementAt(i)[j + 1]) > height ? lowest : false;
      }

      if (lowest) {
        heightMap.getLowPoint(i, j);
        risklevel += height + 1;
      }
    }
  }

  for (var x = 0; x < lines.length; x++) {
    for (var y = 0; y < lines.elementAt(x).length; y++) {
      List<int>? lowPoint = heightMap.getLowPoint(x, y);
      if (lowPoint != null) {
        if (lowpointMap.containsKey(lowPoint.elementAt(0))) {
          if (lowpointMap[lowPoint.elementAt(0)]!
              .containsKey(lowPoint.elementAt(1))) {
            lowpointMap[lowPoint.elementAt(0)]!
                .update(lowPoint.elementAt(1), (value) => value + 1);
          } else {
            lowpointMap[lowPoint.elementAt(0)]!
                .putIfAbsent(lowPoint.elementAt(1), () => 1);
          }
        } else {
          lowpointMap.putIfAbsent(
              lowPoint.elementAt(0), () => {lowPoint.elementAt(1): 1});
        }
      }
    }
  }

  List<int> biggest = new List.filled(3, 0, growable: false);

  for (int x in lowpointMap.keys) {
    for (int y in lowpointMap[x]!.keys) {
      int value = lowpointMap[x]![y]!;
      if (value > biggest.elementAt(0)) {
        biggest[2] = biggest.elementAt(1);
        biggest[1] = biggest.elementAt(0);
        biggest[0] = value;
      } else if (value > biggest.elementAt(1)) {
        biggest[2] = biggest.elementAt(1);
        biggest[1] = value;
      } else if (value > biggest.elementAt(2)) {
        biggest[2] = value;
      }
    }
  }

  int angabe2 =
      biggest.elementAt(0) * biggest.elementAt(1) * biggest.elementAt(2);

  print("Angabe 1: $risklevel");
  print("Angbbe 2: $angabe2");
}

class HeightMap {
  late List<List<List<int?>>> heightMap;
  HeightMap(List<String> input) {
    heightMap = new List.generate(
        input.length,
        (i) => new List.generate(input.elementAt(i).length,
            (j) => [int.parse(input.elementAt(i)[j]), null, null]));
  }

  int? getHeight(int x, int y) {
    if (x < 0 ||
        y < 0 ||
        x >= heightMap.length ||
        y >= heightMap.elementAt(x).length) {
      return null;
    }

    return heightMap.elementAt(x).elementAt(y).elementAt(0);
  }

  List<int>? getLowPoint(int x, int y) {
    if (this.getHeight(x, y) == 9) {
      return null;
    }
    if (heightMap.elementAt(x).elementAt(y).elementAt(1) == null) {
      int minHeight = this.getHeight(x, y)!;
      List<int> minPosition = [x, y];

      int? height = this.getHeight(x - 1, y);
      if (height != null && height < minHeight) {
        minHeight = height;
        minPosition = [x - 1, y];
      }
      height = this.getHeight(x, y + 1);
      if (height != null && height < minHeight) {
        minHeight = height;
        minPosition = [x, y + 1];
      }
      height = this.getHeight(x + 1, y);
      if (height != null && height < minHeight) {
        minHeight = height;
        minPosition = [x + 1, y];
      }
      height = this.getHeight(x, y - 1);
      if (height != null && height < minHeight) {
        minHeight = height;
        minPosition = [x, y - 1];
      }

      if (minPosition.elementAt(0) == x && minPosition.elementAt(1) == y) {
        heightMap[x][y] = [this.getHeight(x, y), x, y];
      } else {
        List<int>? lowestPositon = this
            .getLowPoint(minPosition.elementAt(0), minPosition.elementAt(1));
        heightMap[x][y] = [
          this.getHeight(x, y),
          lowestPositon!.elementAt(0),
          lowestPositon.elementAt(1)
        ];
      }
    }
    return [
      heightMap.elementAt(x).elementAt(y).elementAt(1)!,
      heightMap.elementAt(x).elementAt(y).elementAt(2)!
    ];
  }
}
