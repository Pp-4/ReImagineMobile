import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'status.dart';
import 'point.dart';
import 'space_converter.dart';
import 'image_manipulation.dart';

void main() => runApp(const Root());

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  late Punkt minScale ,maxScale;
  final status = Status(false, false, Punkt(0.3305, -0.041),100, Punkt(0, 0), Punkt(-1.5,-1.5),Punkt(1.5,1.5));
  Icon ikona = const Icon(Icons.motion_photos_on);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {
        status.screenSize = Punkt(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height);
        minScale = status.min * status.ratio(status.screenSize) * status.currentScale;
        maxScale = status.max * status.ratio(status.screenSize) * status.currentScale;
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(//this widget provides interaction with rendering function
                onScaleStart: (details) => status.initialScale = status.currentScale,
                onScaleUpdate: (details) {
                  setState(() {
                    status.addInfo = "Wykryto zoom, liczba palców : ${details.pointerCount}";
                    //zooming
                    //update temporary zoom scale
                    if (details.pointerCount == 2) {
                      status.scaleFactor = details.scale * status.initialScale;
                      status.currentScale = status.scaleFactor;
                    }
                    status.focus = Conv.positionMap(
                        Punkt(0, 0),
                        status.screenSize,
                        minScale,
                        maxScale,
                        details.focalPoint);
                    if (!status.zoomLock) {
                      // update C if zoomLock is false
                      status.C = Conv.positionMap(
                          Punkt(0, 0),
                          status.screenSize,
                          minScale,
                          maxScale,
                          details.focalPoint);
                    }
                    //panning
                    //rate of panning is influenced by zoom
                  });
                },
                onScaleEnd: (details) {
                  setState(() {
                    //zooming
                    if (details.pointerCount == 2) {
                      status.currentScale = status.scaleFactor;
                    }
                    status.addInfo = "";
                    //panning
                    //print(details.velocity);
                  });
                },
                onTap: () {
                  setState(() {
                    status.currentScale *= 0.8;
                    status.addInfo = "Wykryto tapnięcie";
                  });
                },
                onSecondaryTap: () {
                  setState(() {
                    status.currentScale *= 1.25;
                    status.addInfo = "Wykryto tapnięcie drugim przyciskiem";
                  });
                },
                child: Container(
                  //this widget contains rendered image
                  color: Colors.blue,
                  width: double.infinity,
                  child: Center(
                    child: FutureBuilder<ui.Image>(
                      future: Draw.makeImage(
                          status.screenSize.X.toInt(),
                          status.screenSize.Y.toInt(),
                          status.maxIter,
                          status.C,
                          minScale,
                          maxScale,
                          status.resolution),
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
                  child: Text(status.toString()),
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  //reset button
                  onPressed: () => setState(() {
                    minScale = status.min;
                    maxScale = status.max;
                    status.reset();
                  }),
                  tooltip: 'Reset',
                  child: const Icon(Icons.restart_alt),
                ),
                FloatingActionButton(
                  //state button
                  onPressed: () => setState(() {
                    if (status.zoomLock) {
                      ikona = const Icon(Icons.motion_photos_on);
                    } else {
                      ikona = const Icon(Icons.motion_photos_off);
                    }
                    status.zoomLock = !status.zoomLock;
                  }),
                  tooltip: status.cTooltipButton(),
                  child: ikona,
                ),
                FloatingActionButton(onPressed: () =>setState(() {
                  status.maxIter+=log(status.maxIter).toInt();
                }),
                tooltip: "Zwiększ ilość iteracji",
                child: const Icon(Icons.add),
                ),
                FloatingActionButton(onPressed: ()=> setState(() {
                  status.maxIter-=log(status.maxIter).toInt();
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
