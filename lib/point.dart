import "dart:ui";
import "dart:math" as math;
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
  double max() => math.max(X, Y);
  double min() => math.min(X, Y);
  Punkt operator * (var a) {
    if(a is Punkt) { return Punkt(X * a.X, Y * a.Y);}
    else if(a is double) { return Punkt(X*a, Y*a);}
    return this;
  } 
}