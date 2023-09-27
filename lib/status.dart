import 'point.dart';

class Status {
  //wrapper object for various settings and functions
  bool blokadaZmianyC, dragLock,pokazInfo;
  Punkt C;//, fokusPocz = Punkt(0, 0), fokus = Punkt(0, 0);
  final Punkt _poczC;
  Zakres kamera,kameraPocz,rozmiarOkna;
  Mysz mysz;
  int maxLiczbaIteracji;
  final int maxLiczbaIteracjiPocz;
  double skalaPocz = 1.0, tempoSkali = 1.0, skala = 1.0;
  double rozdzielczosc = 1; //doesnt work right now , dont change
  static Kolor kolory = Kolor(0.02,0.04, 0.08);
  Status(
    this.blokadaZmianyC,
    this.dragLock,
    this.C,
    this.maxLiczbaIteracji,
    this.rozmiarOkna,
    this.kameraPocz) :
      _poczC = C,
      maxLiczbaIteracjiPocz = maxLiczbaIteracji,
      kamera = kameraPocz,
      mysz = Mysz(Punkt(0,0),Punkt(0,0),Punkt(0,0)),
      pokazInfo = true;
  String addInfo = "";
  //variable that can be used by external function, to display some info
  @override
  String toString() {
    String outputMessage = "";
    if(pokazInfo){
    outputMessage += "Zmiana C ${blokadaZmianyC ? "nieaktywna" : "aktywna"} \n";
    outputMessage += "Współrzedne C $C\n";
    outputMessage += "Pozycja ${(kamera.min+kamera.max)/2}\n";
    outputMessage += "Przybliżenie ${skala}x \n";
    outputMessage += "Liczba iteracji: $maxLiczbaIteracji\n";
    outputMessage += "Min: ${kamera.min}\nMax: ${kamera.max}\n";
    //outputMessage += "initialScale $initialScale\nscaleFactor $scaleFactor\ncurrentScale $currentScale\n";
    //outputMessage += 'Rozmiar paska: ${window.padding.top}\n';
    outputMessage += addInfo;
  }
  return outputMessage;
  }
  reset() {
    C = _poczC;
    maxLiczbaIteracji = maxLiczbaIteracjiPocz;
    skalaPocz = 1.0;
    skala = 1.0;
    kamera = kameraPocz;
    mysz = Mysz(Punkt(0,0),Punkt(0,0),Punkt(0,0));
    addInfo = "";
  }

  cTooltipButton() => blokadaZmianyC ? "Włącz zmianę C" : "Wyłącz zmianę C";
  infoTooltipButton() => pokazInfo ? "Ukryj szczegóły" : "Pokaż szczegóły";
}