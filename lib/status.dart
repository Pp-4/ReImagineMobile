import 'point.dart';

class Status {
  //wrapper object for various settings and functions
  bool zoomLock,dragLock;
  // ignore: prefer_final_fields
  Punkt C, _defaultC, focus = Punkt(0, 0);
  Punkt min,max;
  Punkt screenSize;
  int maxIter,_defaultIter;
  double initialScale = 1.0, scaleFactor = 1.0, currentScale = 1.0;
  double resolution = 1; //doesnt work right now , dont change
  Status(this.zoomLock,this.dragLock, this.C,this.maxIter, this.screenSize, this.min,this.max) : _defaultC = C,_defaultIter = maxIter;
  String addInfo = ""; 
      //variable that can be used by external function, to display some info
  @override
  String toString() {
    String outputMessage = "";
    outputMessage += "Zmiana C ${zoomLock ? "nieaktywna" : "aktywna"} \n";
    outputMessage += "Współrzedne C ${C.X} Re , ${C.Y} Im \n";
    outputMessage += "Pozycja ${focus.X} Re , ${focus.Y} Im \n";
    outputMessage += "Przybliżenie ${currentScale}x \n";
    outputMessage += "Liczba iteracji: $maxIter\n";
    outputMessage += "Szerokość: ${screenSize.X}px, Wysokość: ${screenSize.Y}px\n";
    outputMessage += "initialScale $initialScale\nscaleFactor $scaleFactor\ncurrentScale $currentScale\n";
    //outputMessage += 'Rozmiar paska: ${window.padding.top}\n';
    outputMessage += addInfo;
    return outputMessage;
  }

  reset() {
    C = _defaultC;
    maxIter = _defaultIter;
    initialScale = 1.0;
    scaleFactor = 1.0;
    currentScale = 1.0;
  }
  cTooltipButton() {
    return zoomLock ? "Włącz zmianę C" : "Wyłącz zmianę C";
  }
  Punkt ratio(Punkt a) {
    //returns screen ratio , useful for keeping 1:1 ratio of fractal image
    Punkt output = Punkt(1, 1);
    if(a.X>a.Y) {output.X = a.X/a.Y;}
    else {output.Y = a.Y/a.X;}
    return output;
  }
}