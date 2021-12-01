import 'dart:io';
import 'dart:convert';

Future<void> main(List<String> args) async {
  int? previous = null;
  int counter1 = 0;

  int? a = null;
  int? b = null;
  int? c = null;
  int counter2 = 0;

  Stream<String> lines = new File("input")
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter());

  await for (var line in lines) {
    int parsedInt = int.parse(line);
    if (previous != null && previous < parsedInt) {
      counter1++;
    }
    previous = parsedInt;

    if (a != null &&
        b != null &&
        c != null &&
        (a + b + c < b + c + parsedInt)) {
      counter2++;
    }
    a = b;
    b = c;
    c = parsedInt;
  }

  print("Aufagbe 1: $counter1");
  print("Aufgabe 2: $counter2");
}
