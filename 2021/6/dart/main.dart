import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  List<int> fish = lines.first.split(",").map((e) => int.parse(e)).toList();

  int firstInterval = 80;
  int secondInterval = 256;

  for (var i = 0; i < firstInterval; i++) {
    fish = List.generate(
        fish.length + fish.where((element) => element == 0).length,
        (index) =>
            index < fish.length ? (fish[index] != 0 ? fish[index] - 1 : 6) : 8);
  }

  int afterFirstInterval = fish.length;

  List<int> fishMap = new List.generate(9, (index) => 0);

  for (var i = 0; i < 9; i++) {
    fishMap[i] = lines.first
        .split(",")
        .map((e) => int.parse(e))
        .where((element) => element == i)
        .length;
  }

  for (var i = 0; i < secondInterval; i++) {
    List<int> newFishMap = new List.generate(fishMap.length, (index) => 0);

    for (var i = 0; i < 9; i++) {
      if (i == 0) {
        newFishMap[8] += fishMap[0];
        newFishMap[6] += fishMap[0];
      } else {
        newFishMap[i - 1] += fishMap[i];
      }
    }
    fishMap = newFishMap;
  }

  int afterSecondInterval =
      fishMap.fold(0, (previousValue, element) => previousValue + element);

  print("Angabe 1: " + afterFirstInterval.toString());
  print("Angabe 2: " + afterSecondInterval.toString());
}
