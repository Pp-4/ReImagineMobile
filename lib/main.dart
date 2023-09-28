import 'package:flutter/material.dart';
import 'package:reimagine_mobile/fractals.dart';
import 'package:reimagine_mobile/widgets/options_bar.dart';
import 'dart:ui' as ui;
import 'dart:math';

import 'point.dart';
import 'status.dart';
import 'aff_trans.dart';
import 'image_manipulation.dart';

void main() => runApp(const Root());

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  final stats = Status(
    false,
    false,
    Punkt(0.3305, -0.041),
    50,
    Zakres(Punkt(0, 0), Punkt(0, 0)),
    Zakres(Punkt(-1.5, -1.5), Punkt(1.5, 1.5)));
    Icon ikona = const Icon(Icons.motion_photos_on);
    Icon ikona2 = const Icon(Icons.info);
    OptionsBar optionsbar = OptionsBar();
    AppBar _buildAppBar() {
      return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      );
    }
  @override
  Widget build(BuildContext context) {
    update() {setState(() {});}
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {
        optionsbar.kolor = Status.kolory;
        optionsbar.dropdown.kolor = Status.kolory;
        optionsbar.update = update;
        optionsbar.dropdown.update = update;
        stats.rozmiarOkna.max = Punkt.size(MediaQuery.of(context).size);
        if(stats.scaleTotal>5 && stats.scaleChange){
          if(CalculateSet.escapeRatio > 0.01){stats.maxLiczbaIteracji = (stats.maxLiczbaIteracji*1.05).toInt();}
          else if(CalculateSet.escapeRatio < 0.015){stats.maxLiczbaIteracji = (stats.maxLiczbaIteracji*0.95).toInt();}
          stats.scaleChange = false;
        }
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: _buildAppBar(),
          drawer: optionsbar,
          body: Stack(
            children: [
              GestureDetector(
                //this widget provides interaction with rendering function
                onScaleStart: (details) {
                  //wykrycie zoomowania palcami , reset skali
                  stats.currScaleFactor = 1;
                  stats.prevScaleFactor = 1;
                  stats.mysz.aktualizuj(details.focalPoint,stats.rozmiarOkna, stats.kamera);
                },
                onScaleUpdate: (details) {
                  setState(() {//zooming
                    //stats.addInfo = "Wykryto zoom, fokus : ${details.focalPoint}";
                    stats.mysz.aktualizuj(details.focalPoint,stats.rozmiarOkna, stats.kamera);
                    //stats.addInfo += "\n ${stats.mysz.pozycjaLogObecna}";
                    stats.prevScaleFactor = stats.currScaleFactor;
                    stats.currScaleFactor = details.scale;
                    double tempScale = stats.currScaleFactor/stats.prevScaleFactor;
                    stats.scaleTotal *= tempScale;
                    stats.scaleChange = (tempScale != 1);
                    if (!stats.blokadaZmianyC && details.pointerCount == 1) {//zmiana c
                      stats.C = AffineTransformations.positionMap(Punkt.offset(details.focalPoint), stats.rozmiarOkna, stats.kamera);
                    } else { //przesuwanie
                      (Zakres, Mysz) wynik = AffineTransformations.pan(stats.kamera, stats.mysz);
                      stats.kamera = wynik.$1;
                      stats.mysz = wynik.$2;
                    }
                    stats.kamera = AffineTransformations.zoom(tempScale, stats.kamera, stats.mysz.pozycjaLogObecna);
                  });
                },
                onTapDown: (details) {
                  stats.mysz.aktualizuj(details.globalPosition,stats.rozmiarOkna, stats.kamera);
                  //stats.addInfo = "${details.globalPosition}";
                },
                onSecondaryTapDown: (details) {
                  stats.mysz.aktualizuj(details.globalPosition,stats.rozmiarOkna, stats.kamera);
                  //stats.addInfo = "${details.globalPosition}";
                },
                onTap: () {
                  setState(() {
                    stats.scaleTotal *= 2;
                    stats.kamera = AffineTransformations.zoom(2, stats.kamera, stats.mysz.pozycjaLogObecna);
                    //stats.addInfo += "\n ${stats.mysz.pozycjaLogObecna}";
                  });
                },
                onSecondaryTap: () {
                  setState(() {
                    stats.scaleTotal *= 0.5;
                    stats.kamera = AffineTransformations.zoom(0.5, stats.kamera, stats.mysz.pozycjaLogObecna);
                    //stats.addInfo = "Wykryto tapnięcie drugim przyciskiem";
                  });
                },
                child: Container(
                  //this widget contains rendered image
                  color: Colors.blue,
                  width: double.infinity,
                  child: Center(
                    child: FutureBuilder<ui.Image>(
                      future: Draw.makeImage(
                          stats.rozmiarOkna.max.X.toInt(),
                          stats.rozmiarOkna.max.Y.toInt(),
                          stats.maxLiczbaIteracji+stats.modLiczbyIteracji,
                          stats.C,
                          stats.kamera.min * AffineTransformations.ratio2(stats.rozmiarOkna.max) / 2,
                          stats.kamera.max * AffineTransformations.ratio2(stats.rozmiarOkna.max) / 2,
                          stats.rozdzielczosc,
                          Status.kolory),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(child: RawImage(image: snapshot.data,));
                        } else {return const Center(child: CircularProgressIndicator());}
                      },
                    ),
                  ),
                ),
              ),
              IgnorePointer(
                  child: Container(
                padding: EdgeInsets.only(
                    top: ui.window.padding.top / ui.window.devicePixelRatio),
                alignment: Alignment.topLeft,
                child: Text(
                  stats.toString(),
                  style: const TextStyle(fontWeight: FontWeight.w600,),
                ),
              ))
            ],
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: ui.window.padding.top / ui.window.devicePixelRatio,width: 10),
                FloatingActionButton(
                  onPressed: () => setState(() {
                      if (stats.pokazInfo) {ikona2 = const Icon(Icons.info_outline);}
                      else {ikona2 = const Icon(Icons.info);
                    }
                    stats.pokazInfo = !stats.pokazInfo;
                  }),
                  tooltip: stats.infoTooltipButton(),
                  child: ikona2,
                ),
                FloatingActionButton(
                  //reset button
                  onPressed: () => setState(() {
                    stats.reset();
                  }),
                  tooltip: 'Reset',
                  child: const Icon(Icons.restart_alt),
                ),
                FloatingActionButton(
                  //state button
                  onPressed: () => setState(() {
                    if (stats.blokadaZmianyC) {
                      ikona = const Icon(Icons.motion_photos_on);
                    } else {
                      ikona = const Icon(Icons.motion_photos_off);
                    }
                    stats.blokadaZmianyC = !stats.blokadaZmianyC;
                  }),
                  tooltip: stats.cTooltipButton(),
                  child: ikona,
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    stats.modLiczbyIteracji +=
                        max(log(stats.modLiczbyIteracji).toInt(), 1);
                  }),
                  tooltip: "Zwiększ ilość iteracji",
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    stats.maxLiczbaIteracji -=
                        log(stats.modLiczbyIteracji).toInt();
                  }),
                  tooltip: "Zmniejsz ilość iteracji",
                  child: const Icon(Icons.remove),
                )
              ]),
        );
      }),
    );
  }
}
