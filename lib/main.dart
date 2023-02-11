import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:io';

import 'fractals.dart';
import 'image_manipulation.dart';
import 'space_converter.dart';

void main() => runApp(const Root());

class Root extends StatefulWidget {
  const Root({super.key});
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  double initialScale = 1.0, scaleFactor = 1.0, currentScale = 1.0;
  Punkt C = Punkt(0.3305, -0.042),
      min = Punkt(-2, -2),
      max = Punkt(2, 2),
      focus = Punkt(0, 0),
      minScale = Punkt(-2,-2),
      maxScale = Punkt(2, 2);
  bool desktop = Platform.isMacOS || Platform.isLinux || Platform.isWindows;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ReImagine Mobile',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Builder(builder: (BuildContext context) {

        var mediaQueryData = MediaQuery.of(context).size;
        final screenSize = Punkt(mediaQueryData.width, mediaQueryData.height-kToolbarHeight);
        print(screenSize);
        return Scaffold(
          appBar: AppBar(
            title: const Text('ReImagine Mobile'),
          ),
          body: GestureDetector(//this widget provides interaction with rendering function
            onScaleStart: (details) {
              setState(() {
                print("${details.focalPoint} start");
                focus = Punkt.offset(details.focalPoint);
              });

              },
            onScaleUpdate: (details) {
              setState(() {
                //zooming
                //update temporary zoom scale
                if (details.pointerCount > 1) {
                  scaleFactor = details.scale;
                  currentScale = scaleFactor * initialScale;

                }
                C = Conv.positionMap(Punkt(0,0),screenSize,minScale,maxScale,details.focalPoint);
                //panning
                //rate of panning is influenced by zoom

                //print("pointer moved by ${(details.focalPoint.dx - focus.X).toStringAsFixed(2)}x, ${(details.focalPoint.dy - focus.Y).toStringAsFixed(2)}y");
              });
            },
            onScaleEnd: (details) {
              setState(() {
                //zooming
                if(details.pointerCount>1){
                  minScale.X = min.X / (currentScale / 2);
                  minScale.Y = min.Y / (currentScale / 2);
                  maxScale.X = max.X / (currentScale / 2);
                  maxScale.Y = max.Y / (currentScale / 2);
                  initialScale = currentScale;
                }
                //panning
                //print(details.velocity);
                //changing C
              });
            },
            onDoubleTapDown: (details){
              setState(() {
                print(details.globalPosition);
                print(details.localPosition);
                print(Conv.positionMap(Punkt(0,0),screenSize,minScale,maxScale,details.localPosition));
                minScale.X *=0.8;
                minScale.Y *=0.8;
                maxScale.X *=0.8;
                maxScale.Y *=0.8;
                initialScale = currentScale*1.25;
              });
            },
            onSecondaryTap: (){
              setState(() {
                minScale.X *=(1/0.8);
                minScale.Y *=(1/0.8);
                maxScale.X *=(1/0.8);
                maxScale.Y *=(1/0.8);
              });
            },
            child: Container(//this widget contains rendered image
              color: Colors.blue,
              width:double.infinity,
              child: Center(
                child: FutureBuilder<ui.Image>(
                  future: Draw.makeImage(screenSize.X.toInt(), screenSize.Y.toInt(), 100, C, minScale, maxScale),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return RawImage(image: snapshot.data);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}