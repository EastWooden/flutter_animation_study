import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:cool_start/Views/Index.dart';
import 'package:cool_start/components/FadeInRoute.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Animation<double> animation1;
  AnimationController animationController;
  double width = ScreenUtil().setWidth(700.0);
  double height = ScreenUtil().setHeight(500.0);
  bool show;

  @override
  void initState() {
    show = false;
    //implement initState
    super.initState();
    print(ScreenUtil().setWidth(700.0));

    animationController = new AnimationController(
        duration: Duration(milliseconds: 5), vsync: this);
    //使用弹性曲线
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    animation = new Tween(begin: 0.0, end: width).animate(animation)
      ..addListener(() {
        setState(() {
          // show = true;
        });
      })
      ..addStatusListener((status) {
        print('status::$status');
        if (status == AnimationStatus.dismissed) {
          show = false;
        }
        if (status == AnimationStatus.completed) {
          show = true;
        }
      });
    animation1 = new Tween(begin: 0.0, end: height).animate(animationController)
      ..addListener(() {
        setState(() {
          // show = true;
        });
      });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight,
      decoration: new BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
            image: ExactAssetImage('images/loginbg.jpg'),
            fit: BoxFit.cover,
          )),
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              bottom: 220,
              child: Container(
                  width: ScreenUtil.getInstance().setWidth(600),
                  height: ScreenUtil.getInstance().setHeight(500),
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 15.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0)
                      ]),
                  child: RaisedButton(
                    color: Colors.red,
                    child: Text('goIndex'),
                    onPressed: () {
                      Navigator.push(context, FadeRoute(builder: (context) {
                        return Index();
                      }));
                    },
                  )),
            ),
            Positioned(
              // top: 0,
              // left: 0,
              child: Container(
                  width: animation.value,
                  height: animation1.value,
                  decoration: new BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            offset: Offset(0.0, 15.0),
                            blurRadius: 15.0,
                            spreadRadius: 1.0)
                      ]),
                  child: RaisedButton(
                      child: Text('go index'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration:
                                Duration(milliseconds: 500), //动画时间为500毫秒
                            pageBuilder: (BuildContext context,
                                Animation animation,
                                Animation secondaryAnimation) {
                              return new FadeTransition(
                                //使用渐隐渐入过渡,
                                opacity: animation,
                                child: Index(), //路由B
                              );
                            },
                          ),
                        );
                      })),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: RaisedButton(
                child: Text('切换动画'),
                onPressed: () {
                  print('动画::$show');
                  if (show) {
                    animationController.reverse();
                  } else {
                    animationController.forward();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    // implement dispose
    super.dispose();
  }
}
