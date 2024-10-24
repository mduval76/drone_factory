import 'package:flutter/material.dart';
import 'dart:math' as math;

class Knob extends StatefulWidget {
  final double startAngle;
  final double minAngle;
  final double maxAngle;
  final double minRange;
  final double maxRange;
  final Color borderColor;

  const Knob({
    super.key,
    required this.startAngle,
    required this.minAngle,
    required this.maxAngle,
    required this.minRange,
    required this.maxRange,
    required this.borderColor
    });

  @override
  State<Knob> createState() => _KnobState();
}

class _KnobState extends State<Knob> {
  final double radius = 12.55;
  late double _cumulativeAngle = 0;
  late double _minAngle;
  late double _maxAngle;
  late double _startAngle;
  late double _currentRangeValue;

  @override
  void initState() {
    super.initState();
    _minAngle = widget.minAngle;
    _maxAngle = widget.maxAngle;
    _startAngle = widget.startAngle;
    _cumulativeAngle = _startAngle;
    _currentRangeValue = (_angleToRange(_cumulativeAngle)).truncateToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   'Angle: ${_cumulativeAngle.toStringAsFixed(3)}',
          //   style : const TextStyle(
          //     color: Colors.white,
          //     fontSize: 12.5,
          //   ),
          // ),
          // Text(
          //   'Range Value: ${_currentRangeValue.toStringAsFixed(3)}',
          //   style : const TextStyle(
          //     color: Colors.white,
          //     fontSize: 12.5,
          //   ),
          // ),
          const SizedBox(height: 20),
          GestureDetector(
            onPanUpdate: _panHandler,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: radius * 2,
                  width: radius * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.borderColor,
                  ),
                ),
                Transform.rotate(
                  angle: _cumulativeAngle,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: radius,
                      width: 2,
                      color: Colors.black,
                      margin: EdgeInsets.only(top: radius - 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _angleToRange(double angle) {
    return widget.minRange +
        (angle - widget.minAngle) *
            (widget.maxRange - widget.minRange) /
            (widget.maxAngle - widget.minAngle);
  }

  void _panHandler(DragUpdateDetails d) {
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    bool panUp = d.delta.dy >= 0.0;
    bool panLeft = d.delta.dx >= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double vert = (onRightSide && panUp) || (onLeftSide && panDown)
        ? yChange * -1
        : yChange;

    double horz = (onTop && panLeft) || (onBottom && panRight)
        ? xChange * -1
        : xChange;

    double rotationalChange = vert + horz;

    setState(() {
      _cumulativeAngle += (rotationalChange / 180) * math.pi;
      _cumulativeAngle = _cumulativeAngle.clamp(_minAngle, _maxAngle);
      _currentRangeValue = _angleToRange(_cumulativeAngle);
    });
  }
}