import "dart:core";
import 'dart:ui';
import 'point.dart';

//this class handles conversion between "pixel space" and "fractal space"
//conversion is needed because pixel space (canvas , images etc.) goes
// from 0,0 to some hundreds of pixels(depending on screen)
// while fractal space only goes form (-2,-2) to (2,2)

class Conv {
  //methods for changing numbers between canvas range and internal range

  static Punkt normalizePoint(Punkt a, Punkt min, Punkt max) => Punkt(
      (min.X - a.X).abs() / (max.X - min.X).abs(),
      (min.Y - a.Y).abs() / (max.Y - min.Y).abs());

  //normalizes point on (0 to 1) scale

  static Punkt denormalizePoint(Punkt a, Punkt min, Punkt max) => Punkt(
      a.X * (max.X - min.X).abs() + min.X, a.Y * (max.Y - min.Y).abs() + min.Y);

  //denormalizes point on (Min to Max) scale

  static int stringToInt(String a) =>
      int.tryParse(a) != null ? int.parse(a) : -1;

  //tries to convert string into number , returns -1 if it fails

  static Punkt positionMap(
      Punkt min1, Punkt max1, Punkt min2, Punkt max2, Offset point) {
    //first : converts x,y point form (min1,max1) scale to (min2,max2)
    // scale , where min1 ,min2 ,max1 ,2 are x,y coordinates
    //second: returns converted position
    Punkt temp = Punkt(point.dx,(point.dy-max1.Y).abs());
    print(temp);
    return Conv.denormalizePoint(
        Conv.normalizePoint(temp, min1, max1), min2, max2);
  }
}
