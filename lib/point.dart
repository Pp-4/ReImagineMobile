import "dart:ui";
import "dart:math" as math;
import "aff_trans.dart";
class Punkt {
  //object for handling pairs of coords with basic operator overloads
  double X, Y;
  Punkt(this.X, this.Y);
  //named constructors for creating Punkt from two-value objects
  Punkt.offset(Offset a)
      : X = a.dx,
        Y = a.dy;
  Punkt.size(Size a)
      : X = a.width,
        Y = a.height;
  @override
  String toString() => '${X.toStringAsFixed(5)} Re, ${Y.toStringAsFixed(5)} Im';
  double max() => math.max(X, Y);
  double min() => math.min(X, Y);

  //overloads for Punkt and double , passing anything else will return unchanged Punkt
  Punkt operator *(var a) {
    if (a is Punkt) {
      return Punkt(X * a.X, Y * a.Y);
    } else if (a is double) {
      return Punkt(X * a, Y * a);
    }
    return this;
  }

  Punkt operator /(var a) {
    if (a is Punkt) {
      return Punkt(X / a.X, Y / a.Y);
    } else if (a is double) {
      return Punkt(X / a, Y / a);
    }
    return this;
  }

  Punkt operator +(var a) {
    if (a is Punkt) {
      return Punkt(X + a.X, Y + a.Y);
    } else if (a is double) {
      return Punkt(X + a, Y + a);
    }
    return this;
  }

  Punkt operator -(var a) {
    if (a is Punkt) {
      return Punkt(X - a.X, Y - a.Y);
    } else if (a is double) {
      return Punkt(X - a, Y - a);
    }
    return this;
  }
}
class Zakres {
  Punkt min,max;
  Zakres(this.min, this.max);
  @override
  String toString() => '${min.toString()} ${max.toString()}';
}
class Mysz {
  Punkt pozycjaFizyczna,pozycjaLogObecna,pozycjaLogPoprzednia;
  Mysz(this.pozycjaFizyczna,this.pozycjaLogObecna,this.pozycjaLogPoprzednia);
  void aktualizuj(Offset pozycjaFizycznaMyszki,Zakres fizyczny,Zakres logiczny,{bool odwracanieOsiY = false}){
    pozycjaFizyczna = Punkt.offset(pozycjaFizycznaMyszki);
    if(odwracanieOsiY) {
      pozycjaFizyczna.Y = (pozycjaFizyczna.Y - fizyczny.max.Y).abs();
    }
    pozycjaLogPoprzednia = pozycjaLogObecna;
    pozycjaLogObecna = AffineTransformations.positionMap(pozycjaFizyczna, fizyczny, logiczny);
  }
}
class Kolor {
  double kolor1,kolor2,kolor3;
  int rownanie;
  Kolor(this.kolor1,this.kolor2,this.kolor3,this.rownanie);
}