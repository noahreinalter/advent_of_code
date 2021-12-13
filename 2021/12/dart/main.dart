import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  Map<String, List<String>> paths = new Map();

  lines.forEach((element) {
    List<String> splitLine = element.split("-");

    paths.putIfAbsent(
        splitLine.elementAt(0), () => new List.empty(growable: true));
    paths[splitLine.elementAt(0)]!.add(splitLine.elementAt(1));

    paths.putIfAbsent(
        splitLine.elementAt(1), () => new List.empty(growable: true));
    paths[splitLine.elementAt(1)]!.add(splitLine.elementAt(0));
  });

  int numberOfWays =
      recursiveVisit("start", paths, new List.empty(growable: true));

  int numberOfWays2 =
      recursiveVisit2("start", paths, new List.empty(growable: true));

  print("Angabe 1: $numberOfWays");
  print("Augabe 2: $numberOfWays2");
}

int recursiveVisit(
    String cave, Map<String, List<String>> paths, List<String> vistited) {
  if (cave == "end") {
    return 1;
  }

  int numberOfWays = 0;
  List<String> newVisitedList = new List.from(vistited);

  if (cave.toLowerCase() == cave) {
    newVisitedList.add(cave);
  }

  for (var newCave in paths[cave]!) {
    if (!vistited.contains(newCave)) {
      numberOfWays += recursiveVisit(newCave, paths, newVisitedList);
    }
  }
  return numberOfWays;
}

int recursiveVisit2(
    String cave, Map<String, List<String>> paths, List<String> vistited) {
  if (cave == "end") {
    return 1;
  }

  int numberOfWays = 0;
  List<String> newVisitedList = new List.from(vistited);

  if (cave.toLowerCase() == cave) {
    newVisitedList.add(cave);
  }

  for (var newCave in paths[cave]!) {
    if (!vistited.contains(newCave)) {
      numberOfWays += recursiveVisit2(newCave, paths, newVisitedList);
    } else if (newCave != "start") {
      numberOfWays += recursiveVisit(newCave, paths, newVisitedList);
    }
  }
  return numberOfWays;
}
