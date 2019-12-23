import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './HeroAnmationRouteB.dart';
import 'package:cool_start/components/ InterwovenAnimation.dart';
import 'package:cool_start/components/MySlideTransition.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> with SingleTickerProviderStateMixin {
  // const Index({Key key}) : super(key: key);
  AnimationController controller;
  int number = 0;
  int maxNumber = 10;
  int animationDurationTime = 100;


  @override
  initState() {
     super.initState();
    number = 0;
    controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this);
    autoCal();
  }

  Future<Null> _playAnimation() async {
    Fluttertoast.showToast(
        msg: "This is Center Short Toast",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 14
    );
    try {
      //先正向执行动画
      await controller.forward().orCancel;
      //再反向执行动画
      await controller.reverse().orCancel;
    } on TickerCanceled {
      // the animation got canceled, probably because we were disposed
    }
  }

  void autoCal() {
    print('定时器自动执行');
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (maxNumber <= 10 && maxNumber > 5) {
          animationDurationTime = 500;
        } else if (maxNumber <= 5) {
          animationDurationTime = 2000;
        }
        if (maxNumber <= 0) {
          timer.cancel();
          timer = null;

        }
        maxNumber--;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('第一个Hero页面'),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            child: InkWell(
              child: Hero(
                tag: "avatar", //唯一标记，前后两个路由页Hero的tag必须相同
                child: ClipOval(
                  child: Image.asset(
                    "images/avator.jpg",
                    width: 50.0,
                  ),
                ),
              ),
              onTap: () {
                //打开B路由
                Navigator.push(context, PageRouteBuilder(pageBuilder:
                    (BuildContext context, Animation animation,
                        Animation secondaryAnimation) {
                  return new FadeTransition(
                    opacity: animation,
                    child: Scaffold(
                      appBar: AppBar(
                        title: Text("第二个hero页面"),
                      ),
                      body: HeroAnimationRouteB(),
                    ),
                  );
                }));
              },
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              _playAnimation();
            },
            child: Center(
              child: Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                child: StaggerAnimation(controller: controller),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Column(
                children: <Widget>[
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      // var tween =
                      //     Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0));
                      //执行缩放动画
                      return MySlideTransition(
                          child: child,
                          direction: AxisDirection.up,
                          position: animation);
                    },
                    child: Text(
                      '$maxNumber',
                      //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                      key: ValueKey<int>(maxNumber),
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ),
                  Container(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(80),
                    child: RaisedButton(
                      color: Colors.orange,
                      shape: StadiumBorder(),
                      child: Text('++'),
                      onPressed: () {
                        print('object:::$number');
                        setState(() {
                          number++;
                        });
                      },
                    ),
                  ),
                ],
              ))
        ],
      )),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    // implement dispose
    super.dispose();
  }
}
