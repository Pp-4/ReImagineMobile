import "dart:core";
import 'point.dart';
//ported form c#

class CalculateSet {
  //Magic happens here
  static double escapeRatio = 0;
  Punkt C = Punkt(0, 0), min = Punkt(-2, -2), max = Punkt(2, 2);
  int resX = 0, resY = 0;
  int typRowniania =
      0; //0 - julia, 1 - mandelbrott, 2 - phoenix, 3 - burning ship
  late List<List<Punkt>> pointMatrix; //stores iterated coordinates
  late List<List<double>> depthMatrix;
  //stores escape depth for each point <-this is important part that you want to do display after calling iteration function

  CalculateSet(this.resX, this.resY,
      [Punkt? C, Punkt? min, Punkt? max, int? typRowniania]) {
    if (C != null) this.C = C;
    if (max != null) this.max = max;
    if (min != null) this.min = min;
    if (typRowniania != null) this.typRowniania = typRowniania;
    resX = resX.abs();
    resY = resY.abs();
    //matrices must be generated this way, otherwise all rows will be copy of the first one
    pointMatrix = List.generate(resX, (_) => List.filled(resY, Punkt(0, 0)));
    depthMatrix = List.generate(resX, (_) => List.filled(resY, 0.0));
    _populateMatrix();
  }

  fastIteration(int iterations) //less accurate but faster
  {
    int x = resX, y = resY;
    if (typRowniania % 2 == 0) {
      for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
          Punkt Z = pointMatrix[i][j];
          depthMatrix[i][j] = _helpCalc(Z, C, iterations);
        }
      }
      escapeRatio = escapeRatio/(resX*resY);
      return depthMatrix;
    } else {
      for (int i = 0; i < x; i++) {
        for (int j = 0; j < y; j++) {
          C = pointMatrix[i][j];
          Punkt Z = Punkt(0, 0);
          depthMatrix[i][j] = _helpCalc(Z, C, iterations);
        }
      }
      escapeRatio = escapeRatio/(resX*resY);
      return depthMatrix;
    }
  }

  double _helpCalc(Punkt z, Punkt c, int iterations) {
    //return number of iterations after which point diverges , return -1 if it doesn't
    for (int i = 0; i <= iterations; i++) {
      if (_finalCheck(z, 2)) return i.toDouble();
      if(typRowniania<2) {
        z = _nextPoint(z, c);
      } else {
        z = _nextPointB(z, c);
      }
    }
    escapeRatio++;
    return -1.0;
  }

  void reset() {
    //reset calculations and bring all states to default values
    depthMatrix = List.filled(resX, List<double>.filled(resY, 0));
  }

  static Punkt _nextPoint(Punkt a, Punkt c) => Punkt(a.X * a.X - a.Y * a.Y + c.X, 2.0 * a.X * a.Y + c.Y);//mandelbrott/julia
  static Punkt _nextPointB(Punkt a, Punkt c) => Punkt(a.X * a.X - a.Y * a.Y + c.X, 2.0 *( a.X * a.Y).abs() + c.Y);//burning ship
  //calculate point's next position

  static bool _finalCheck(Punkt a, [int escapeRadius = 2]) =>
      a.X.abs() > escapeRadius || a.Y.abs() > escapeRadius;
  //check if point is outside escape radius

  _populateMatrix() {
    //2d linspace function
    Punkt delta =
        Punkt((max.X - min.X) / (resX - 1), (max.Y - min.Y) / (resY - 1));
    //print("liczenie od: $min, do: $max, delta: $delta");
    for (int i = 0; i < resX; i++) {
      for (int j = 0; j < resY; j++) {
        pointMatrix[i][j] = Punkt(min.X + delta.X * i, min.Y + delta.Y * j);
      }
    }
    //print("test");
  }
}

String printMatrix<T>(List<List<T>> matrix) {
  String output = "";
  for (int i = 0; i < matrix[0].length; i++) {
    for (int j = 0; j < matrix.length; j++) {
      output += '${matrix[j][i]} '.padLeft(3);
    }
    output += '\n';
  }
  return output;
}
