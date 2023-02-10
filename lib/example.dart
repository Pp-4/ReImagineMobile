import 'dart:math';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sensors Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

double ballSize = 120;

class _MyHomePageState extends State<MyHomePage> {
  static const int _snakeRows = 35;
  static const int _snakeColumns = 35;
  static const double _snakeCellSize = 10.0;

  double left = 0,top = 0,left2=0,top2=0;
  bool selected = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensor Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.black38),
              ),
              child: SizedBox(
                height: _snakeRows * _snakeCellSize,
                width: _snakeColumns * _snakeCellSize,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(seconds: 2),
                      curve: Curves.fastOutSlowIn,
                      child: Align(
                        alignment: selected ? AlignmentDirectional(left,top) : AlignmentDirectional(left2, top2),
                        child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                selected = true;
                                if(left>1 || left<-1) {left -= details.delta.dx/(_snakeColumns * _snakeCellSize)*5;}
                                else {left += details.delta.dx/(_snakeColumns * _snakeCellSize)*5;}
                                if(top>1 || top<-1) {top -= details.delta.dy/(_snakeRows * _snakeCellSize)*5;}
                                else {top += details.delta.dy/(_snakeRows * _snakeCellSize)*5;}
                              });
                            },
                            onPanEnd: (details) {
                              setState(() {
                                selected = false;
                                left2 = min(max(left+details.velocity.pixelsPerSecond.dx/(_snakeColumns * _snakeCellSize*5),-1),1);
                                top2 = min(max(top+details.velocity.pixelsPerSecond.dy/(_snakeRows * _snakeCellSize*5),-1),1);
                                left = left2;
                                top = top2;
                              });
                            },
                            child: Icon(Icons.circle,color: Colors.cyan, size: ballSize)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}