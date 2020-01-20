import 'dart:async';

import 'package:flutter/material.dart';

import './digitalClockPainter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clock Challenge',
      theme: ThemeData(
        textTheme:
            TextTheme(body1: TextStyle(color: Colors.white, fontSize: 180)),
        primarySwatch: Colors.blue,
      ),
      home: DigitalClock(title: 'Digital Clock'),
    );
  }
}

class DigitalClock extends StatefulWidget {
  DigitalClock({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime dateTime = DateTime.now();
  Animation<double> animation, animation1;
  AnimationController controller;
  bool animateMidDots = false;

  startTimer({var duration, Function handleTimeout}) {
    return Timer.periodic(duration, (timer) {
      handleTimeout();
      setState(() {
        animateMidDots = !animateMidDots;
      });
      timer.cancel();
    });
  }

  void setDateTime() {
    setState(() {
      dateTime = DateTime.now();
    });
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      reverseDuration: Duration(seconds: 13),
      duration: Duration(seconds: 13),
      vsync: this,
    );

    final Animation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.linear,
      reverseCurve: Curves.linear,
    );

    animation = Tween<double>(begin: 20, end: 80).animate(curve)
      ..addListener(() {
        if (animation.value == 80.0) {
          controller.reverse();
        } else if (animation.value == 20.0) {
          controller.forward();
        }
      });

    controller.forward();
  }

  String forTimeLessThan10(int time) {
    var splitNum = [];
    splitNum.addAll(time.toString().split(''));

    if (time < 10) {
      final firstNum = splitNum.removeAt(0);
      splitNum = ['0', firstNum];
      return '${splitNum[0]}${splitNum[1]}';
    }
    return time.toString();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    startTimer(duration: Duration(seconds: 1), handleTimeout: setDateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 5 / 3,
          child: Container(
            color: Color.fromRGBO(246, 241, 242, 1),
            child: CustomPaint(
              painter: DigitalClockPainter(
                dy: (((animation.value) - 50) * (-1)),
                dateTime: dateTime,
              ),
              child: FittedBox(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('${forTimeLessThan10(dateTime.hour)}'),
                    Container(
                      width: 30,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 15,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius: animateMidDots ? 10 : 15,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 100),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              maxRadius: animateMidDots ? 15 : 10,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    Text('${forTimeLessThan10(dateTime.minute)}'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
