const readline = require('readline');
const fs = require('fs');

let previous = null;
let counter1 = 0;

let a = null;
let b = null;
let c = null;
let counter2 = 0;

const readInterface = readline.createInterface({
    input: fs.createReadStream('../input'),
});

readInterface.on('line', function (line) {
    const parsedInt = parseInt(line, 10);
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
}).on('close', function (line) {
    console.log("Aufagbe 1: " + counter1);
    console.log("Aufgabe 2: " + counter2);
});