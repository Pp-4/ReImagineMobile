import 'point.dart';

class Status {//wrapper object for various settings
  bool zoomLock;
  Punkt C, _defaultC, focus = Punkt(0, 0);
  double initialScale = 1.0, scaleFactor = 1.0, currentScale = 1.0;
  Status(this.zoomLock, this.C) : _defaultC = C;
  @override
  String toString() {
    String outputMessage = "";
    outputMessage += "Tryb zmiany C ${zoomLock ? "nieaktywny" : "aktywny"} \n";
    outputMessage += "Współrzedne C ${C.X} Re , ${C.Y} Im \n";
    outputMessage += "Pozycja ${focus.X} Re , ${focus.Y} Im \n";
    outputMessage += "Przybliżenie ${scaleFactor}x \n";
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