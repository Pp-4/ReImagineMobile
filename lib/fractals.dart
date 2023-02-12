import "dart:core";
import "dart:math";
import "dart:ui";
//ported form c#

class JuliaSet {
  //Magic happens here
  Punkt C = Punkt(0, 0), min = Punkt(-2, -2), max = Punkt(2, 2);
  int resX = 0, resY = 0;
  late List<List<Punkt>> pointMatrix;
  //stores iterated coordinates
  late List<List<double>> depthMatrix;
  //stores escape depth for each point <-this is important part that you want to do display after calling iteration function
  bool slowMethodUsed = false;
  // if slow iteration method was used point matrix must be reset
  int currentDepth = 0;
  //how many iterations were calculated - not used in fast iteration

  JuliaSet(this.resY, this.resX, [Punkt? C, Punkt? min, Punkt? max]) {
    //resY being before resX is a feature ,not a bug , X should be still passed as the first parameter , Y being second
    if (C != null) this.C = C;
    if (max != null) this.max = max;
    if (min != null) this.min = min;
    resX = resX.abs();
    resY = resY.abs();
    //matrices must be generated this way, otherwise all rows will be copy of the first one
    pointMatrix = List.generate(resX, (_) => List.filled(resY, Punkt(0,0)));
    depthMatrix = List.generate(resX, (_) => List.filled(resY, 0.0));
    populateMatrix();
  }

  void slowIteration([int iterations = 1]) {
    //calculate next position for each point in matrix , useful if you don't want to get final image but rather iterate to get approximation
    slowMethodUsed = true;
    for (int h = 0; h < iterations; h++) {
      currentDepth++;
      for (int i = 0; i < resX; i++) {
        for (int j = 0; j < resY; j++) {
          if (depthMatrix[i][j] < 1) {
            //number different than 0 means that point had already escaped and can be omitted form calculations
            pointMatrix[i][j] = _nextPoint(pointMatrix[i][j], C);
            depthMatrix[i][j] = _finalCheck(pointMatrix[i][j]) ? escape(currentDepth, pointMatrix[i][j]): -1;
            //mark point's depth of escape
          }
        }
      }
    }
  }

  double escape(int iterations, Punkt a) {
    double temp = sqrt(a.X * a.X + a.Y * a.Y);
    return iterations + 1 - ((ln2 / temp) / ln2);
  }

  fastIteration(int iterations) //less accurate but faster
  {
    int x = resX, y = resY;
    for (int i = 0; i < x; i++) {
      for (int j = 0; j < y; j++) {
        depthMatrix[i][j] = _juliaHelp(pointMatrix[i][j], iterations);
      }
    }
    return depthMatrix;
  }

  double _juliaHelp(Punkt a, int iterations) {
    //return number of iterations after which point diverges , return -1 if it doesn't
    for (int i = 0; i <= iterations; i++) {
      if (_finalCheck(a, 2)) return i.toDouble();
      a = _nextPoint(a, C);
    }
    return -1.0;
  }

  void reset() {
    //reset calculations and bring all states to default values
    currentDepth = 0;
    depthMatrix = List.filled(resX, List<double>.filled(resY, 0));
    if (slowMethodUsed) populateMatrix();
  }

  static Punkt _nextPoint(Punkt a, Punkt c) => Punkt(a.X * a.X - a.Y * a.Y + c.X,2.0 * a.X * a.Y + c.Y);
  //calculate point's next position

  static bool _finalCheck(Punkt a, [int escapeRadius = 2]) => a.X.abs() > escapeRadius || a.Y.abs() > escapeRadius;
  //check if point is outside escape radius

  populateMatrix() {
    Punkt delta = Punkt((max.X-min.X)/(resX - 1),(max.Y-min.Y)/(resY - 1));
    for (int i = 0; i < resX; i++) {
      for (int j = 0; j < resY; j++) {
        pointMatrix[i][j] = Punkt(min.X + delta.X * i, min.Y + delta.Y * j);
      }
    }
  }
}

String printMatrix<T>(List<List<T>> matrix) {
  String output = ' ';
  for (int i = 0; i < matrix.length; i++) {
    for (int j = 0; j < matrix[0].length; j++) {
      output += '${matrix[i][j]} '.padLeft(3);
    }
    output += '\n';
  }
  return output;
}

class Punkt {
  //using this instead if Point because only double type is used
  double X, Y;
  Punkt(this.X, this.Y);
  Punkt.offset(Offset A):X = A.dx,Y = A.dy;
  @override
  String toString() => '${X.toStringAsFixed(5)},${Y.toStringAsFixed(5)} ';
}