import 'point.dart';

class Status {//wrapper object for various settings
  bool zoomLock;
  Punkt C, _defaultC, focus = Punkt(0, 0);
  int maximumDepth = 100;
  double initialScale = 1.0, scaleFactor = 1.0, currentScale = 1.0;
  double resolution = 1;//doesnt work right now , dont change
  Status(this.zoomLock, this.C) : _defaultC = C;
  @override
  String toString() {
    String outputMessage = "";
    outputMessage += "Tryb zmiany C ${zoomLock ? "nieaktywny" : "aktywny"} \n";
    outputMessage += "Współrzedne C ${C.X} Re , ${C.Y} Im \n";
    outputMessage += "Pozycja ${focus.X} Re , ${focus.Y} Im \n";
    outputMessage += "Przybliżenie ${scaleFactor}x \n";
    outputMessage += "Liczba iteracji: ${maximumDepth}";
    return outputMessage;
  }

  reset() {
    C = _defaultC;
    initialScale = 1.0;
    scaleFactor = 1.0;
    currentScale = 1.0;
  }
  cTooltipButton(){
    return zoomLock?"Włącz zmianę C":"Wyłącz zmianę C";
  } 
}