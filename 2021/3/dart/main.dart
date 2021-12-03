import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  int gamma = 0;
  int epsilon = 0;

  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  for (var i = 0; i < lines.first.length; i++) {
    int zeros = 0;
    int ones = 0;

    for (var line in lines) {
      if (line[i] == "0") {
        zeros++;
      } else if (line[i] == "1") {
        ones++;
      }
    }
    if (zeros > ones) {
      gamma = gamma << 1;
      epsilon = epsilon << 1 | 1;
    } else {
      gamma = gamma << 1 | 1;
      epsilon = epsilon << 1;
    }
  }

  int oxygenGeneratorRating = findNumber(lines, true, "1");
  int cO2ScrubberRating = findNumber(lines, false, "0");

  print("Gamma rate: $gamma");
  print("Epsilon rate: $epsilon");
  print("Aufgabe 1: " + (gamma * epsilon).toString());

  print("Oxygen generator rating: $oxygenGeneratorRating");
  print("CO2 scrubber rating: $cO2ScrubberRating");
  print("Aufgabe 2: " + (oxygenGeneratorRating * cO2ScrubberRating).toString());
}

int findNumber(List<String> inputString, bool mostCommen, String ifEqual) {
  int elementLength = inputString.first.length;
  for (var i = 0; i < elementLength; i++) {
    int zeros = inputString.where((element) => element[i] == "0").length;
    int ones = inputString.where((element) => element[i] == "1").length;

    if (zeros == ones) {
      inputString =
          inputString.where((element) => element[i] == ifEqual).toList();
    } else if ((zeros > ones && mostCommen) || (zeros < ones && !mostCommen)) {
      inputString = inputString.where((element) => element[i] == "0").toList();
    } else if ((ones > zeros && mostCommen) || (ones < zeros && !mostCommen)) {
      inputString = inputString.where((element) => element[i] == "1").toList();
    }

    if (inputString.length == 1) {
      return int.parse(inputString.first, radix: 2);
    }
  }
  return 1;
}
