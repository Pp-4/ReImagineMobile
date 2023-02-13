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
  Punkt min = Punkt(-1.5, -1.5),
      max = Punkt(1.5, 1.5),
      minScale = Punkt(-1.5, -1.5),
      maxScale = Punkt(1.5, 1.5);
  final status = Status(
    false,
    Punkt(0.3305, -0.042),
  );
  Icon ikona = const Icon(Icons.add_box);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {
        final screenSize = Punkt(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height);
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                //this widget provides interaction with rendering function
                onScaleUpdate: (details) {
                  setState(() {
                    //zooming
                    //update temporary zoom scale
                    if (details.pointerCount == 2) {
                    status.scaleFactor = details.scale;
                    status.currentScale = status.scaleFactor * status.initialScale;
                    }
                    status.focus = 
                      Conv.positionMap(
                        Punkt(0,0),
                        screenSize,
                        minScale,
                        maxScale,
                        details.focalPoint
                      );
                    if (!status.zoomLock) {
                      // update C if zoomLock is false
                      status.C = Conv.positionMap(Punkt(0, 0), screenSize,
                          minScale, maxScale, details.focalPoint);
                    }
                    //panning
                    //rate of panning is influenced by zoom
                  });
                },
                onScaleEnd: (details) {
                  setState(() {
                    //zooming
                    if (details.pointerCount == 2) {
                      minScale.X = min.X / (status.currentScale / 2);
                      minScale.Y = min.Y / (status.currentScale / 2);
                      maxScale.X = max.X / (status.currentScale / 2);
                      maxScale.Y = max.Y / (status.currentScale / 2);
                      status.initialScale = status.currentScale;
                    }
                    //panning
                    //print(details.velocity);
                  });
                },
                onTapDown: (details) {
                  setState(() {
                    minScale.multiply(0.8);
                    maxScale.multiply(0.8);
                    status.initialScale = status.currentScale * 1.25;
                  });
                },
                onSecondaryTap: () {
                  setState(() {
                    minScale.multiply(1.25);
                    maxScale.multiply(1.25);
                    status.initialScale = status.currentScale * 0.8;
                  });
                },
                child: Container(
                  //this widget contains rendered image
                  color: Colors.blue,
                  width: double.infinity,
                  child: Center(
                    child: FutureBuilder<ui.Image>(
                      future: Draw.makeImage(
                          screenSize.X.toInt(),
                          screenSize.Y.toInt(),
                          status.maximumDepth,
                          status.C,
                          minScale,
                          maxScale,
                          status.resolution),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return RawImage(image: snapshot.data);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                ),
              ),
              Text(status.toString()),
            ],
          ),
          floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  //reset button
                  onPressed: () => setState(() {
                    minScale = min;
                    maxScale = max;
                    status.reset();
                  }),
                  tooltip: 'Reset',
                  child: const Icon(
                    Icons.restart_alt,
                  ),
                ),
                FloatingActionButton(
                  //state button
                  onPressed: () => setState(() {
                    if (status.zoomLock) {
                      ikona = const Icon(Icons.add_box);
                    } else {
                      ikona = const Icon(Icons.add_box_outlined);
                    }
                    status.zoomLock = !status.zoomLock;
                  }),
                  tooltip: status.cTooltipButton(),
                  child: ikona,
                ),
              ]),
        );
      }),
    );
  }
}
