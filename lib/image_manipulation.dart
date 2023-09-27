import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:async';
import 'dart:ui' as ui;

import 'fractals.dart';
import 'point.dart';
class Draw {
  static Future<ui.Image> makeImage( //create image object
      int width, int height, int iteration, Punkt focus, Punkt min, Punkt max, double resolution,Kolor gradient,int rownanie) {
    resolution = (resolution > 1) ? 1 : resolution;
    JuliaSet js2 = JuliaSet((width*resolution).toInt(), (height*resolution).toInt(), focus, min, max,rownanie);
    //print("rysowanie od $min, do $max");
    js2.fastIteration(iteration);

    final c = Completer<ui.Image>();
    final pixels = Draw.serialisation(js2.depthMatrix,gradient);
    ui.decodeImageFromPixels(
      pixels.buffer.asUint8List(),
      (width*resolution).toInt(),
      (height*resolution).toInt(),
      ui.PixelFormat.rgba8888,
      c.complete,
      targetHeight: height,
      targetWidth: width
    );
    return c.future;
  }

  static Int32List serialisation(List<List<double>> input, Kolor gradient) {
    //convert depth matrix to RGBA int32 list ,using continuous function
    int x = input.length, y = input[0].length,pointer = 0;
    Int32List output = Int32List(x * y); //height * length ,4 channels
    if(Endian.host == Endian.big) {
      //check in which direction bytes are stored
      for (int i = 0; i < x; i++) {
       for (int j = 0; j < y; j++) {
          double temp = input[i][j]; //R+G+B+A , A is always 255
          output[pointer++] = (temp != -1)//check if depth is -1
              ? (_color(temp, gradient.kolor1, 0) << 24)
              + (_color(temp, gradient.kolor2, 1) << 16)
              + (_color(temp, gradient.kolor3, 2) << 8)
              + 255 : (temp == 0) ? ~0 :0;//-1 is colored white , 0 is colored black
        }
      }
    }
    else {//reversed order of bytes in int32 -> ABGR
      
        for (int j = 0; j < y; j++) {
          for (int i = 0; i < x; i++) {
          double temp = input[i][j]; //R+G+B+A , A is always 255
          output[pointer++] = (temp != -1) //check if depth is -1
              ? (_color(temp, gradient.kolor1, 0) << 0)
              + (_color(temp, gradient.kolor2, 1) << 8)
              + (_color(temp, gradient.kolor3, 2) << 16)
              + 0xff000000 : 0xffff0000;//-1 is colored white , 0 is colored black
        }
      }
    }
    return output;
  }
  static int _color(double depth, double tempo, int offset) => (math.sin(tempo * depth + offset) * 230 + 25).abs().toInt();
  // Coloring function for single channel, convert double to value between 0 and 255
} 