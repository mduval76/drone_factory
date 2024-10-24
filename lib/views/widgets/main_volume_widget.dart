import 'package:flutter/material.dart';

class MainVolumeWidget extends StatefulWidget {
  const MainVolumeWidget({
    super.key, 
    required this.leftChannelVolume, 
    required this.rightChannelVolume
  });

  final double leftChannelVolume;
  final double rightChannelVolume;

  @override
  State<MainVolumeWidget> createState() => _MainVolumeWidgetState();
}

class _MainVolumeWidgetState extends State<MainVolumeWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _leftChannelVolumeAnimation;
  late Animation<double> _rightChannelVolumeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 5),
      vsync: this,
    );

    _leftChannelVolumeAnimation = Tween<double>(begin: 0, end: widget.leftChannelVolume)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _rightChannelVolumeAnimation = Tween<double>(begin: 0, end: widget.rightChannelVolume)
        .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _animationController.forward();
  }

  @override
  void didUpdateWidget(MainVolumeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.leftChannelVolume != widget.leftChannelVolume ||
        oldWidget.rightChannelVolume != widget.rightChannelVolume) {
      _leftChannelVolumeAnimation = Tween<double>(
              begin: _leftChannelVolumeAnimation.value, end: widget.leftChannelVolume)
          .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _rightChannelVolumeAnimation = Tween<double>(
              begin: _rightChannelVolumeAnimation.value, end: widget.rightChannelVolume)
          .animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

      _animationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidgetHeight = MediaQuery.of(context).size.height;

    return Container(
        height: double.infinity,
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          color: Colors.transparent,
          border: Border(
            right: BorderSide(
              color: Color.fromARGB(255, 255, 4, 192),
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            AnimatedBuilder(
              animation: _leftChannelVolumeAnimation,
              builder: (context, child) {
                return Container(
                  height: _leftChannelVolumeAnimation.value * 0.25 * currentWidgetHeight,
                  width: 15,
                  color: Colors.white,
                );
              },
            ),
            const SizedBox(width: 1),
            AnimatedBuilder(
              animation: _rightChannelVolumeAnimation,
              builder: (context, child) {
                return Container(
                  height: _rightChannelVolumeAnimation.value * 0.25 * currentWidgetHeight,
                  width: 15,
                  color: Colors.white,
                );
              },
            ),
          ],
        ),
      );
  }
}