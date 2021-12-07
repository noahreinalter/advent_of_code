import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  List<int> crabs = lines.first.split(",").map((e) => int.parse(e)).toList();

  int minHorizontalPosition = crabs.reduce(min);
  int maxHorizontalPosition = crabs.reduce(max);

  int optimum = maxHorizontalPosition * crabs.length;
  int optimum2 =
      (maxHorizontalPosition * (maxHorizontalPosition + 1) / 2 * crabs.length)
          .toInt();

  for (var i = minHorizontalPosition; i <= maxHorizontalPosition; i++) {
    int currentOptimum = 0;
    int currentOPtimum2 = 0;
    crabs.forEach((element) {
      currentOptimum += (i - element).abs();
      currentOPtimum2 +=
          ((i - element).abs() * (((i - element).abs() + 1) / 2)).toInt();
    });

    if (currentOptimum < optimum) {
      optimum = currentOptimum;
    }

    if (currentOPtimum2 < optimum2) {
      optimum2 = currentOPtimum2;
    }
  }

  print("Angabe 1: $optimum");
  print("Angabe 2: $optimum2");
}
