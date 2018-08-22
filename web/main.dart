import 'dart:async';
import 'dart:html';
import 'dart:math';

void main() async {
  final CanvasElement canvas = querySelector('#canvas');
  final CanvasRenderingContext2D ctx = canvas.context2D;

  canvas
    ..width = window.innerWidth
    ..height = window.innerHeight;

  final int fontSize = 10;
  final int columnCount = canvas.width ~/ fontSize;

  List<int> primeNumbers = new List<int>();
  List<int> drops = new List<int>.filled(columnCount, 1);

  void draw() {
    ctx.fillStyle = 'rgba(0, 0, 0, 0.05)';
    ctx.fillRect(0, 0, canvas.width, canvas.height);

    ctx.fillStyle = '#00ff00';
    ctx.font = fontSize.toString() + 'px Arial';

    drops.asMap().forEach((i, item) {
      final int index = new Random().nextInt(primeNumbers.length).floor();
      final int primeNumber = primeNumbers[index];
      final String text = primeNumber.toString();

      ctx.fillText(text, i * fontSize, item * fontSize);

      final bool isDropUnderScreen = item * fontSize > canvas.height;
      final bool randomStuff = new Random().nextInt(1000) > 975;

      if (isDropUnderScreen && randomStuff) {
        drops[i] = 0;
      }

      drops[i]++;
    });
  }

  await for (int primeNumber in generatePrimeNumbers().take(500)) {
    primeNumbers.add(primeNumber);
  }

  new Timer.periodic(new Duration(milliseconds: 33), (Timer timer) {
    draw();
  });
}

Stream<int> generatePrimeNumbers() async* {
  int currentNumber = 2;

  while (true) {
    if (isNumberPrime(currentNumber)) {
      yield currentNumber;
    }

    currentNumber += 1;
  }
}

bool isNumberPrime(final int number) {
  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      return false;
    }
  }

  return true;
}
