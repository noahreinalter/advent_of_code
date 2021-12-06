import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  List<List<int?>> ground = new List.generate(
      1000, (index) => new List.generate(1000, (index) => null));
  List<List<int?>> ground2 = new List.generate(
      1000, (index) => new List.generate(1000, (index) => null));

  for (var line in lines) {
    List<String> points = line.split(" -> ");
    List<int> point1 = points[0].split(",").map((e) => int.parse(e)).toList();
    List<int> point2 = points[1].split(",").map((e) => int.parse(e)).toList();

    if (point1[0] == point2[0]) {
      if (point1[1] > point2[1]) {
        List<int> cache = point1;
        point1 = point2;
        point2 = cache;
      }

      for (var i = point1[1]; i <= point2[1]; i++) {
        ground[point1[0]][i] = (ground[point1[0]][i] ?? 0) + 1;
        ground2[point1[0]][i] = (ground2[point1[0]][i] ?? 0) + 1;
      }
    } else if (point1[1] == point2[1]) {
      if (point1[0] > point2[0]) {
        List<int> cache = point1;
        point1 = point2;
        point2 = cache;
      }

      for (var i = point1[0]; i <= point2[0]; i++) {
        ground[i][point1[1]] = (ground[i][point1[1]] ?? 0) + 1;
        ground2[i][point1[1]] = (ground2[i][point1[1]] ?? 0) + 1;
      }
    } else if ((point1[0] - point2[0]).abs() == (point1[1] - point2[1]).abs()) {
      if (point1[0] > point2[0]) {
        List<int> cache = point1;
        point1 = point2;
        point2 = cache;
      }

      for (var x = 0; x <= point2[0] - point1[0]; x++) {
        ground2[point1[0] + x][point1[1] + ((point2[1] - point1[1]).sign * x)] =
            (ground2[point1[0] + x]
                        [point1[1] + ((point2[1] - point1[1]).sign * x)] ??
                    0) +
                1;
      }
    }
  }

  int numberOfCordinatesGreaterOrEqual2Exercise1 = 0;
  int numberOfCordinatesGreaterOrEqual2Exercise2 = 0;

  for (var x = 0; x < ground.length; x++) {
    for (var y = 0; y < ground.first.length; y++) {
      if ((ground[x][y] ?? 0) >= 2) {
        numberOfCordinatesGreaterOrEqual2Exercise1++;
      }
      if ((ground2[x][y] ?? 0) >= 2) {
        numberOfCordinatesGreaterOrEqual2Exercise2++;
      }
    }
  }

  print("Angabe 1: $numberOfCordinatesGreaterOrEqual2Exercise1");
  print("Angabe 2: $numberOfCordinatesGreaterOrEqual2Exercise2");
}
