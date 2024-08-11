// author: Lukas Horst

int ceilingDivision(int dividend, int divisor) {
  if (divisor == 0) {
    throw ArgumentError("Divisor can't be zero.");
  }
  return (dividend ~/ divisor) + (dividend % divisor != 0 ? 1 : 0);
}

int floorDivision(int dividend, int divisor) {
  if (divisor == 0) {
    throw ArgumentError("Divisor can't be zero.");
  }
  return dividend ~/ divisor;
}

double round(double number, {int digits = 0}) {
  String roundedString = number.toStringAsFixed(digits);
  return double.parse(roundedString);
}