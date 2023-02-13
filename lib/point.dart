import "dart:ui";
class Punkt {
  //using this instead if Point because only double type is used
  double X, Y;
  Punkt(this.X, this.Y);
  Punkt.offset(Offset A):X = A.dx,Y = A.dy;
  @override
  String toString() => '${X.toStringAsFixed(5)},${Y.toStringAsFixed(5)} ';
  void multiply(double a, {double? b}){
      X *= a;
      Y *= (b == null) ? a : b;
  }
}