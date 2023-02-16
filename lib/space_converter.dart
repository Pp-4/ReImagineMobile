import 'point.dart';

//this class handles conversion between "pixel space" and "fractal space"
//conversion is needed because pixel space (canvas , images etc.) goes
// from 0,0 to some hundreds of pixels(depending on screen)
// while fractal space only goes form (-2,-2) to (2,2) (usually)

class Conv {

  static Punkt _normalizePoint(Punkt a, Punkt min, Punkt max) => Punkt(
      (min.X - a.X).abs() / (max.X - min.X).abs(),
      (min.Y - a.Y).abs() / (max.Y - min.Y).abs()
      );//normalizes point on (0 to 1) scale

  static Punkt _denormalizePoint(Punkt a, Punkt min, Punkt max) => Punkt(
      a.X * (max.X - min.X).abs() + min.X,
      a.Y * (max.Y - min.Y).abs() + min.Y
      );//denormalizes point on (Min to Max) scale

  static Punkt positionMap(
    Punkt min1, //converts x,y point form (min1,max1) to (min2,max2)
    Punkt max1, // where min1 ,max1 are source 
    Punkt min2, // range , and min2,max are destination range
    Punkt max2, // example : point(1,0) on (-1,-1) (1,1) range
    Punkt pos) {// will be scalled to (2,1) on (0,0)(2,2)
    pos.Y = (pos.Y - max1.Y).abs();
    return Conv._denormalizePoint( Conv._normalizePoint(pos, min1, max1), min2, max2);
  }

  static Punkt zoom(Punkt initialPosition, Punkt pointOfZoom,double scale) {
    Punkt output = initialPosition;
    //print("Punkt początkowy: $output, Skala: $scale, Mijece przybliżenia: $pointOfZoom");
    output -= pointOfZoom; //translation
    output /= scale;       //zooming
    output += pointOfZoom; //translation
    //print("Punkt wynikowy: $output\n");
    return output;
  }
}