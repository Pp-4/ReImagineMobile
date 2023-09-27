import 'package:flutter/material.dart';
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
  final stats = Status(false, false, Punkt(0.3305, -0.041),100, Zakres(Punkt(0,0), Punkt(0,0)), Zakres(Punkt(-1.5, -1.5), Punkt(1.5, 1.5)));
      /*some C's to test :
      Punkt(0.259184, 0.001126),500
      Punkt(0.3305, -0.041),100
      */
  Icon ikona = const Icon(Icons.motion_photos_on);
  Icon ikona2 = const Icon(Icons.info);
  OptionsBar optionsbar = OptionsBar();
  AppBar _buildAppBar(){
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {
        optionsbar.kolor = Status.kolory;
        stats.rozmiarOkna.max = Punkt.size(MediaQuery.of(context).size);
        //stats.addInfo = AffineTransformations.ratio2(stats.rozmiarOkna.max).toString();
        //stats.kamera = AffineTransformations.ratio(stats.kameraPocz, stats.rozmiarOkna.min - stats.rozmiarOkna.max);
        //stats.kamera = AffineTransformations.zoom(stats.skala,stats.kamera,stats.mysz.pozycjaLogObecna);
        //stats.kameraMax = ((stats.kameraMaxPocz * screenRatio-stats.fokus) / stats.skala) + stats.fokus;

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar:_buildAppBar(),

          drawer: optionsbar,
          body: Stack(
            children: [
              GestureDetector(
                //this widget provides interaction with rendering function
                onScaleStart: (details) {//wykrycie zoomowania palcami , ustalenie pozycji i skali
                  stats.skalaPocz = stats.skala;
                  stats.mysz.pozycjaFizyczna = Punkt.offset(details.focalPoint);
                  stats.mysz.pozycjaLogPoprzednia = stats.mysz.pozycjaLogObecna;
                  stats.mysz.pozycjaLogObecna = AffineTransformations.positionMap(stats.mysz.pozycjaFizyczna, stats.rozmiarOkna, stats.kamera);
                },
                onScaleUpdate: (details) {
                  setState(() {
                    stats.addInfo = "Wykryto zoom, liczba palców : ${details.pointerCount}";
                    //zooming
                    //update temporary zoom scale
                    if (details.pointerCount == 2) {//
                      stats.tempoSkali = details.scale * stats.skalaPocz;
                      stats.skala = stats.tempoSkali;
                      stats.mysz.pozycjaFizyczna = Punkt.offset(details.focalPoint);
                      stats.mysz.pozycjaLogPoprzednia = stats.mysz.pozycjaLogObecna;
                      stats.mysz.pozycjaLogObecna = AffineTransformations.positionMap(stats.mysz.pozycjaFizyczna, stats.rozmiarOkna, stats.kamera);
                      stats.kamera = AffineTransformations.zoom(stats.skala, stats.kamera, stats.mysz.pozycjaLogObecna);
                    }
                    if (details.pointerCount == 1) {
                    if (!stats.blokadaZmianyC) {// update C if zoomLock is false
                      stats.C = AffineTransformations.positionMap(Punkt.offset(details.focalPoint),stats.rozmiarOkna,stats.kamera);
                    }
                    else {
                      (Zakres,Mysz) wynik = AffineTransformations.pan(stats.kamera, stats.mysz);
                      stats.kamera = wynik.$1;
                      stats.mysz = wynik.$2;
                    }
                    }

                    //panning
                    //rate of panning is influenced by zoom
                  });
                },
                onScaleEnd: (details) {
                  setState(() {
                    stats.addInfo = "";
                    if(stats.mysz.pozycjaFizyczna != Punkt(0,0)){
                      //print("zoom w punkcie $zoomPointInPixels");
                    //stats.currFocus = Conv.positionMap(Punkt(0,0), stats.screenSize, stats.currentMin, stats.currentMax, stats.initialFocus);
                    //stats.initialFocus = stats.currFocus;
                    }
                  });
                },
                onTapDown: (details) {
                  stats.mysz.pozycjaFizyczna = Punkt.offset(details.globalPosition);
                  stats.mysz.pozycjaFizyczna.Y = (stats.mysz.pozycjaFizyczna.Y-stats.rozmiarOkna.max.Y).abs();
                  stats.mysz.pozycjaLogPoprzednia = stats.mysz.pozycjaLogObecna;
                  stats.mysz.pozycjaLogObecna = AffineTransformations.positionMap(stats.mysz.pozycjaFizyczna, stats.rozmiarOkna, stats.kamera);
                },
                onTap: () {
                  setState(() {
                    stats.skala *= 2;
                    stats.kamera = AffineTransformations.zoom(2, stats.kamera, stats.mysz.pozycjaLogObecna);
                    stats.addInfo = "Wykryto tapnięcie";
                  });
                },
                onSecondaryTap: () {
                  setState(() {
                    stats.skala *= 0.5;
                    stats.kamera = AffineTransformations.zoom(0.5, stats.kamera,  stats.mysz.pozycjaLogObecna);
                    stats.addInfo = "Wykryto tapnięcie drugim przyciskiem";
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
                          stats.maxLiczbaIteracji,
                          stats.C,
                          stats.kamera.min*AffineTransformations.ratio2(stats.rozmiarOkna.max)/2,
                          stats.kamera.max*AffineTransformations.ratio2(stats.rozmiarOkna.max)/2,
                          stats.rozdzielczosc,
                          Status.kolory,
                          Status.rownanie),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Center(
                              child: RawImage(
                            image: snapshot.data,
                            //width: screenSize.X,
                            //height: screenSize.Y,
                          ));
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
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
                  child: Text(stats.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                    
                ),
              ))
            ],
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: ui.window.padding.top / ui.window.devicePixelRatio,width:10),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    if(stats.pokazInfo) {
                      ikona2 = const Icon(Icons.info_outline);
                    }
                    else {
                      ikona2 = const Icon(Icons.info);
                    }
                    stats.pokazInfo =! stats.pokazInfo;
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
                    stats.maxLiczbaIteracji += max(log(stats.maxLiczbaIteracji).toInt(), 1);
                  }),
                  tooltip: "Zwiększ ilość iteracji",
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    stats.maxLiczbaIteracji -= log(stats.maxLiczbaIteracji).toInt();
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
