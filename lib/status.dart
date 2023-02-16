import 'point.dart';

class Status {
  //wrapper object for various settings and functions
  bool zoomLock, dragLock,showInfo;
  Punkt C, initialFocus = Punkt(0, 0), currFocus = Punkt(0, 0);
  final Punkt _defaultC;
  Punkt initialMin, initialMax, currentMin, currentMax;
  Punkt screenSize;
  int maxIter;
  final int _defaultIter;
  double initialScale = 1.0, scaleFactor = 1.0, currScale = 1.0;
  double resolution = 1; //doesnt work right now , dont change
  Status(
    this.zoomLock,
    this.dragLock,
    this.C,
    this.maxIter,
    this.screenSize,
    this.initialMin,
    this.initialMax) :
      _defaultC = C,
      _defaultIter = maxIter,
      currentMin = initialMin,
      currentMax = initialMax,
      showInfo = true;
  String addInfo = "";
  //variable that can be used by external function, to display some info
  @override
  String toString() {
    String outputMessage = "";
    if(showInfo){
    outputMessage += "Zmiana C ${zoomLock ? "nieaktywna" : "aktywna"} \n";
    outputMessage += "Współrzedne C $C\n";
    outputMessage += "Pozycja $currFocus\n";
    outputMessage += "Przybliżenie ${currScale}x \n";
    outputMessage += "Liczba iteracji: $maxIter\n";
    outputMessage += "Min: $currentMin\nMax: $currentMax\n";
    //outputMessage += "initialScale $initialScale\nscaleFactor $scaleFactor\ncurrentScale $currentScale\n";
    //outputMessage += 'Rozmiar paska: ${window.padding.top}\n';
    outputMessage += addInfo;
  }
  return outputMessage;
  }
  reset() {
    C = _defaultC;
    maxIter = _defaultIter;
    initialScale = 1.0;
    currScale = 1.0;
    initialFocus = Punkt(0, 0);
    currFocus = Punkt(0, 0);
    currentMin = initialMin;
    currentMax = initialMax;
  }

  cTooltipButton() => zoomLock ? "Włącz zmianę C" : "Wyłącz zmianę C";
  infoTooltipButton() => showInfo ? "Ukryj szczegóły" : "Pokaż szczegóły";

  Punkt ratio(Punkt a) {
    //returns screen ratio , useful for keeping 1:1 ratio of fractal image
    Punkt output = Punkt(1, 1);
    if (a.X > a.Y) {
      output.X = a.X / a.Y;
    } else {
      output.Y = a.Y / a.X;
    }
    return output;
  }
}