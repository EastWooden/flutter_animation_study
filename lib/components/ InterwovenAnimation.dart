import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StaggerAnimation extends StatelessWidget {
  final Animation<double> controller;
  Animation<double> height;
  Animation<EdgeInsets> padding;
  Animation<Color> color;
  StaggerAnimation({Key key, this.controller}) : super(key: key) {
    //高度动画
    height = Tween<double>(
      begin: .0,
      end: 300.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          0.0, 0.6, //间隔，前60%的动画时间
          curve: Curves.ease,
        ),
      ),
    );

    padding = Tween<EdgeInsets>(
            begin: EdgeInsets.only(left: 0.0),
            end: EdgeInsets.only(left: 100.0))
        .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0, 0.6, //间隔，前60%的动画时间
              curve: Curves.ease,
            )));

    color =
        ColorTween(begin: Colors.blue, end: Colors.red).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.6, 1.0, //间隔，前60%的动画时间
              curve: Curves.ease,
            )));
  }

  Widget _buildAnimation(BuildContext context,Widget child) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: padding.value,
      child: Container(
        color: color.value,
        width: ScreenUtil().setWidth(100.0),
        height: height.value,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}
