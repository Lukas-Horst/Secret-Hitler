// author: Lukas Horst

class MathFunctions{

  static int ceilingDivision(int dividend, int divisor) {
    if (divisor == 0) {
      throw ArgumentError("Divisor can't be zero.");
    }
    return (dividend ~/ divisor) + (dividend % divisor != 0 ? 1 : 0);
  }

}