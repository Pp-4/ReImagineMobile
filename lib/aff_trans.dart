import 'point.dart';

class AffineTransformations {
  static Zakres zoom(double skalaPrzyblizenia, Zakres kamera, Punkt punktPrzyblizenia) {
    Zakres nowaKamera = Zakres(kamera.min - punktPrzyblizenia, kamera.max - punktPrzyblizenia);
    nowaKamera.min /= skalaPrzyblizenia;
    nowaKamera.max /= skalaPrzyblizenia;
    nowaKamera.min += punktPrzyblizenia;
    nowaKamera.max += punktPrzyblizenia;
    return nowaKamera;
  }

  static (Zakres, Mysz) pan(Zakres kamera, Mysz mysz) {
    Punkt delta =  mysz.pozycjaLogObecna - mysz.pozycjaLogPoprzednia;
    Zakres nowaKamera = Zakres(kamera.min - delta, kamera.max - delta);
    Mysz nowaMysz = Mysz(mysz.pozycjaFizyczna,mysz.pozycjaLogObecna, mysz.pozycjaLogPoprzednia);
    nowaMysz.pozycjaLogObecna -= delta;
    nowaMysz.pozycjaLogPoprzednia -= delta;
    return (nowaKamera, nowaMysz);
  }

  static Zakres ratio(Zakres kamera, Punkt rozmiarOdniesienia) {
    Punkt proporcja = ratio2(rozmiarOdniesienia) / ratio2(kamera.min - kamera.max);
    Punkt srodek = (kamera.min + kamera.max) / 2;
    Zakres nowaKamera = Zakres(kamera.min-srodek, kamera.max-srodek);
    nowaKamera.min /= proporcja;
    nowaKamera.max /= proporcja;
    nowaKamera.min += srodek;
    nowaKamera.max += srodek;
    return nowaKamera;
  }

  static Punkt ratio2(Punkt a) {
    Punkt out = Punkt(1, 1);
    if (a.X < a.Y) {
      out.X = a.X / a.Y;
    } else {
      out.Y = a.Y / a.X;
    }
    return out;
  }
    static Punkt _normalizuj(Punkt punkt, Zakres odniesienie) => Punkt(
      (odniesienie.min.X - punkt.X).abs() / (odniesienie.max.X - odniesienie.min.X).abs(),
      (odniesienie.min.Y - punkt.Y).abs() / (odniesienie.max.Y - odniesienie.min.Y).abs()
      );//normalizes point on (0 to 1) scale

  static Punkt _denormalizuj(Punkt punkt, Zakres odniesienie) => Punkt(
      punkt.X * (odniesienie.max.X - odniesienie.min.X).abs() + odniesienie.min.X,
      punkt.Y * (odniesienie.max.Y - odniesienie.min.Y).abs() + odniesienie.min.Y
      );//denormalizes point on (Min to Max) scale

  static Punkt positionMap(Punkt pozycja, Zakres fizyczny, Zakres logiczny) {
  //converts x,y point form (min1,max1) to (min2,max2) where min1 ,max1 are source 
  // range , and min2,max are destination range example : point(1,0) on (-1,-1) (1,1) range
  // will be scalled to (2,1) on (0,0)(2,2)
    //pozycja.Y = (pozycja.Y - fizyczny.max.Y).abs();
    return _denormalizuj(_normalizuj(pozycja, fizyczny), logiczny);
  }
}
