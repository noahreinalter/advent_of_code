import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<int> max = new List.filled(3, 0);
  int cache = 0;

  Stream<String> lines = new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter());

  await for (var line in lines) {
    int? parsedInt = int.tryParse(line);
    if (parsedInt == null) {
      if (cache > max[0]) {
        max[2] = max[1];
        max[1] = max[0];
        max[0] = cache;
      } else if (cache > max[1]) {
        max[2] = max[1];
        max[1] = cache;
      } else if (cache > max[2]) {
        max[2] = cache;
      }
      cache = 0;
    } else {
      cache += parsedInt;
    }
  }

  int aufgabe1 = max.elementAt(0);
  int aufgabe2 = max.reduce((value, element) => value + element);

  print("Aufagbe 1: $aufgabe1");
  print("Aufgabe 2: $aufgabe2");
}
