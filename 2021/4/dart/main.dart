import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  List<String> lines = await new File(p.relative("../input"))
      .openRead()
      .map(utf8.decode)
      .transform(new LineSplitter())
      .toList();

  List<List<List<Map<int, bool>>>> boards = new List.generate(
      ((lines.length - 2) / 6).ceil(),
      (index) => new List.generate(
          5, (index) => new List.generate(5, (index) => {1: false})));

  List<int> randomNumbers = lines.first
      .split(",")
      .map((e) => int.parse(e, radix: 10))
      .toList(growable: true);

  for (var i = 2; i < lines.length; i++) {
    if (((i - 1) % 6) - 1 != -1) {
      int index = 0;
      lines
          .elementAt(i)
          .split(" ")
          .where((element) => element != "")
          .toList()
          .map((e) => int.parse(e))
          .toList()
          .forEach((element) {
        boards
            .elementAt(((i - 1) / 6).ceil() - 1)
            .elementAt(((i - 1) % 6) - 1)[index] = {element: false};
        index++;
      });
    }
  }

  List<int> points = new List.empty(growable: true);

  List<int> winners = new List.empty(growable: true);

  for (var i = 0; i < randomNumbers.length; i++) {
    int randomNumber = randomNumbers[i];

    for (var i = 0; i < boards.length; i++) {
      if (!winners.contains(i)) {
        checkNumber(boards.elementAt(i), randomNumber);

        if (isWinner(boards.elementAt(i))) {
          points.add(caluculate(boards.elementAt(i), randomNumber));
          winners.add(i);
        }
      }
    }
  }

  print("Aufgabe 1: " + points.first.toString());
  print("Aufgabe 2: " + points.last.toString());
}

void checkNumber(List<List<Map<int, bool>>> board, int number) {
  board.forEach((row) {
    row.forEach((element) {
      if (element.keys.first == number) {
        element.update(number, (value) => true);
      }
    });
  });
}

bool isWinner(List<List<Map<int, bool>>> board) {
  for (var x = 0; x < 5; x++) {
    bool isWinner = true;
    for (var y = 0; y < 5; y++) {
      if (board[x][y].containsValue(false)) {
        isWinner = false;
      }
    }
    if (isWinner) {
      return true;
    }
  }

  for (var y = 0; y < 5; y++) {
    bool isWinner = true;
    for (var x = 0; x < 5; x++) {
      if (board[x][y].containsValue(false)) {
        isWinner = false;
      }
    }
    if (isWinner) {
      return true;
    }
  }

  return false;
}

int caluculate(List<List<Map<int, bool>>> board, int number) {
  int value = 0;

  board.forEach((element) {
    element.forEach((element) {
      if (element.containsValue(false)) {
        value += element.keys.first;
      }
    });
  });

  return value * number;
}
