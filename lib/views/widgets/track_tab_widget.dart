import 'package:drone_factory/models/track_model.dart';
import 'package:flutter/material.dart';

class TrackTabWidget extends StatefulWidget {
  final TrackModel trackModel;
  final Color color;
  final int selectedTrackIndex;

  const TrackTabWidget({
    super.key, 
    required this.trackModel, 
    required this.color, 
    required this.selectedTrackIndex
  });

  @override
  State<TrackTabWidget> createState() => _TrackTabWidgetState();
}

class _TrackTabWidgetState extends State<TrackTabWidget> {
  late Color _color;

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }
  //TODO: Implement lower opacity background color for active tracks
  //TODO: Implement muted grey background color for muted tracks
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.trackModel.trackId == widget.selectedTrackIndex;
    bool isActive = widget.trackModel.wavetable != Wavetable.none;
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? _color : isActive ? widget.trackModel.isMuted ? Colors.grey.withOpacity(0.75) : _color.withOpacity(0.66) : Colors.black,
              border: isSelected ? 
              Border(
              left: BorderSide(
                color: _color,
                width: 2,
              ),
              top: BorderSide(
                color: _color,
                width: 2,
              ),
              bottom: BorderSide(
                color: _color,
                width: 2,
              ),
              right: BorderSide.none,
            ) :
            Border.all(
              color: _color,
              width: 2,
            ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 9
                  ),
                  child: Text(
                  '${widget.trackModel.trackId + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Container(
          width: 5.0,
          decoration: BoxDecoration(
            color: isSelected ? _color : isActive ? widget.trackModel.isMuted ? Colors.grey.withOpacity(0.75) : _color.withOpacity(0.66) : Colors.black,
            border: isSelected ? 
              Border(
                left: const BorderSide(
                  color: Colors.transparent,
                  width: 0,
                ),
                top: BorderSide(
                  color: _color,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: _color,
                  width: 2,
                ),
              ) :
              Border.all(
                color: Colors.black,
                width: 2,
              ), 
          ),
        ),
      ],
    );
  }
}