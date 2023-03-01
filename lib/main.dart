import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

import 'point.dart';
import 'status.dart';
import 'space_converter.dart';
import 'image_manipulation.dart';

void main() => runApp(const Root());

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  final stats = Status(false, false, Punkt(0.3305, -0.041),100, Punkt(0, 0),
      Punkt(-1.5, -1.5), Punkt(1.5, 1.5));
      /*some C's to test :
      Punkt(0.259184, 0.001126),500
      Punkt(0.3305, -0.041),100
      */
  Icon ikona = const Icon(Icons.motion_photos_on);
  Icon ikona2 = const Icon(Icons.info);
  Offset? zoomPointInPixels;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {
        stats.screenSize = Punkt.size(MediaQuery.of(context).size);
        final screenRatio = stats.ratio(stats.screenSize);
        stats.currentMin = ((stats.initialMin * screenRatio-stats.currFocus) / stats.currScale) + stats.currFocus;
        stats.currentMax = ((stats.initialMax * screenRatio-stats.currFocus) / stats.currScale) + stats.currFocus;
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                //this widget provides interaction with rendering function
                onScaleStart: (details) {
                  stats.initialScale = stats.currScale;
                },
                onScaleUpdate: (details) {
                  setState(() {
                    stats.addInfo =
                        "Wykryto zoom, liczba palców : ${details.pointerCount}";
                    //zooming
                    //update temporary zoom scale
                    if (details.pointerCount == 2) {
                      stats.scaleFactor = details.scale * stats.initialScale;
                      stats.currScale = stats.scaleFactor;
                      zoomPointInPixels = details.localFocalPoint;
                      stats.initialFocus = Punkt.offset(zoomPointInPixels!);
                      stats.initialFocus.Y = (stats.initialFocus.Y-stats.screenSize.Y).abs();
                    }
                    if (!stats.zoomLock) {
                      // update C if zoomLock is false
                      stats.C = Conv.positionMap(
                          Punkt(0,0),
                          stats.screenSize,
                          stats.currentMin,
                          stats.currentMax,
                          Punkt.offset(details.focalPoint));
                    }
                    //panning
                    //rate of panning is influenced by zoom
                  });
                },
                onScaleEnd: (details) {
                  setState(() {
                    stats.addInfo = "";
                    if(zoomPointInPixels != null){
                      //print("zoom w punkcie $zoomPointInPixels");
                    //stats.currFocus = Conv.positionMap(Punkt(0,0), stats.screenSize, stats.currentMin, stats.currentMax, stats.initialFocus);
                    //stats.initialFocus = stats.currFocus;
                    }
                  });
                },
                onTapDown: (details) {
                  stats.initialFocus = Punkt.offset(details.globalPosition);
                  stats.initialFocus.Y = (stats.initialFocus.Y-stats.screenSize.Y).abs();
                },
                onSecondaryTapDown: (details) {
                  stats.initialFocus = Punkt.offset(details.globalPosition);
                  stats.initialFocus.Y = (stats.initialFocus.Y-stats.screenSize.Y).abs();
                },
                onTap: () {
                  setState(() {
                    stats.currScale *= 2;
                    stats.currFocus = Conv.positionMap(Punkt(0,0), stats.screenSize, stats.currentMin, stats.currentMax, stats.initialFocus);
                    stats.initialFocus = stats.currFocus;
                    stats.addInfo = "Wykryto tapnięcie";
                  });
                },
                onSecondaryTap: () {
                  setState(() {
                    stats.currScale *= 0.5;
                    stats.currFocus = Conv.positionMap(Punkt(0,0), stats.screenSize, stats.currentMin, stats.currentMax, stats.initialFocus);
                    stats.initialFocus = stats.currFocus;
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
                          stats.screenSize.X.toInt(),
                          stats.screenSize.Y.toInt(),
                          stats.maxIter,
                          stats.C,
                          stats.currentMin,
                          stats.currentMax,
                          stats.resolution),
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
                    if(stats.showInfo) {
                      ikona2 = const Icon(Icons.info_outline);
                    }
                    else {
                      ikona2 = const Icon(Icons.info);
                    }
                    stats.showInfo =! stats.showInfo;
                }),
                tooltip: stats.infoTooltipButton(),
                child: ikona2,
                ),
                FloatingActionButton(
                  //reset button
                  onPressed: () => setState(() {
                    stats.currentMin = stats.initialMin;
                    stats.currentMax = stats.initialMax;
                    stats.reset();
                  }),
                  tooltip: 'Reset',
                  child: const Icon(Icons.restart_alt),
                ),
                FloatingActionButton(
                  //state button
                  onPressed: () => setState(() {
                    if (stats.zoomLock) {
                      ikona = const Icon(Icons.motion_photos_on);
                    } else {
                      ikona = const Icon(Icons.motion_photos_off);
                    }
                    stats.zoomLock = !stats.zoomLock;
                  }),
                  tooltip: stats.cTooltipButton(),
                  child: ikona,
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    stats.maxIter += max(log(stats.maxIter).toInt(), 1);
                  }),
                  tooltip: "Zwiększ ilość iteracji",
                  child: const Icon(Icons.add),
                ),
                FloatingActionButton(
                  onPressed: () => setState(() {
                    stats.maxIter -= log(stats.maxIter).toInt();
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
