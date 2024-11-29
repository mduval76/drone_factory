import 'package:drone_factory/providers/base_frequency_provider.dart';
import 'package:drone_factory/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class BaseFrequencyWidget extends StatefulWidget {
  const BaseFrequencyWidget({super.key});

  @override
  State<BaseFrequencyWidget> createState() => _BaseFrequencyWidgetState();
}

class _BaseFrequencyWidgetState extends State<BaseFrequencyWidget> {
  int _baseFreqWhole = AudioConstants.wholeBaseFreq;
  int _baseFreqDecimal = AudioConstants.decimalBaseFreq;

  BaseFrequencyProvider? _baseFrequencyProvider;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newBaseFrequencyProvider = Provider.of<BaseFrequencyProvider>(context);
    if (_baseFrequencyProvider != newBaseFrequencyProvider) {
      _baseFrequencyProvider?.removeListener(_onBaseFrequencyChanged);
      _baseFrequencyProvider = newBaseFrequencyProvider;
      _baseFrequencyProvider!.addListener(_onBaseFrequencyChanged);
      
      final baseFrequency = _baseFrequencyProvider!.baseFrequency;
      _baseFreqWhole = baseFrequency.floor();
      _baseFreqDecimal = ((baseFrequency - _baseFreqWhole) * 1000).round();
    }
  }
  
  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _onBaseFrequencyChanged() {
    setState(() {
      final baseFrequency = _baseFrequencyProvider!.baseFrequency;
      _baseFreqWhole = baseFrequency.floor();
      _baseFreqDecimal = ((baseFrequency - _baseFreqWhole) * 1000).round();
    });
  }

  double _calculateBaseFrequency() {
    return _baseFreqWhole + (_baseFreqDecimal / 1000.0);
  }

  void _updateWholeBaseFrequency(int newWholeBaseFreq) {
    if (newWholeBaseFreq < 20) {
      newWholeBaseFreq = 20;
    } else if (newWholeBaseFreq > 999) {
      newWholeBaseFreq = 999;
    }

    setState(() {
      _baseFreqWhole = newWholeBaseFreq;
      _applyFrequencyChange();
    });
  }

  void _updateDecimalBaseFrequency(int newDecimalBaseFreq) {
    if (newDecimalBaseFreq < 0) {
      if (_baseFreqWhole > 20) {
        newDecimalBaseFreq = 999;
        _baseFreqWhole -= 1;
      } 
      else {
        newDecimalBaseFreq = 0;
      }
    }
    else if (newDecimalBaseFreq > 999) {
      if (_baseFreqWhole < 999) {
        newDecimalBaseFreq = 0;
        _baseFreqWhole += 1;
      } 
      else {
        newDecimalBaseFreq = 999;
      }
    }

    setState(() {
      _baseFreqDecimal = newDecimalBaseFreq;
      _applyFrequencyChange();
    });
  }

  void _applyFrequencyChange() {
    final newBaseFrequency = _calculateBaseFrequency();
    _baseFrequencyProvider?.updateBaseFrequency(newBaseFrequency);
  }

  void _startTimer(Function action) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      action();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    const Color borderColor =  Color.fromARGB(255, 255, 4, 192);

    return  SizedBox(
      height: 75,
      width: 100,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: [
                // WHOLE INCREMENT ////////////////////////////////////////////////
                Expanded(
                  child: GestureDetector(
                    onTap: () => _updateWholeBaseFrequency(++_baseFreqWhole),
                    onLongPressStart: (_) => _startTimer(() => _updateWholeBaseFrequency(++_baseFreqWhole)),
                    onLongPressEnd: (_) => _stopTimer(),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          bottom: BorderSide(color: borderColor, width: 0.5),
                          left: BorderSide(color: borderColor, width: 1),
                          right: BorderSide(color: borderColor, width: 0.5),
                        )
                      ),
                      child: const Center(
                          child: Icon(Icons.arrow_drop_up, color: borderColor),
                        ),
                    ),
                  ),
                ),
                // DECIMAL INCREMENT ////////////////////////////////////////////////
                Expanded(
                  child: GestureDetector(
                    onTap: () => _updateDecimalBaseFrequency(++_baseFreqDecimal),
                    onLongPressStart: (_) => _startTimer(() => _updateDecimalBaseFrequency(++_baseFreqDecimal)),
                    onLongPressEnd: (_) => _stopTimer(),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          bottom: BorderSide(color: borderColor, width: 0.5),
                          left: BorderSide(color: borderColor, width: 0.5),
                          right: BorderSide(color: borderColor, width: 1),
                        )
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_drop_up, color: borderColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          top: BorderSide(color: borderColor, width: 0.5),
                          bottom: BorderSide(color: borderColor, width: 0.5,),
                          left: BorderSide(color: borderColor, width: 1),
                          right: BorderSide(color: borderColor, width: 0.5),
                        )
                      ),
                      child: Text(
                        '$_baseFreqWhole', 
                        style: const TextStyle(color: Colors.white, fontSize: 20.0)),
                    ),
                  ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      border: Border(
                        top: BorderSide(color: borderColor, width: 0.5),
                        bottom: BorderSide(color: borderColor, width: 0.5),
                        left: BorderSide(color: borderColor, width: 0.5),
                        right: BorderSide(color: borderColor, width: 1),
                      )
                    ),
                    child: Text(
                      _baseFreqDecimal.toString().padLeft(3, '0'), 
                      style: const TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // WHOLE DECREMENT ////////////////////////////////////////////////
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _updateWholeBaseFrequency(--_baseFreqWhole),
                    onLongPressStart: (_) => _startTimer(() => _updateWholeBaseFrequency(--_baseFreqWhole)),
                    onLongPressEnd: (_) => _stopTimer(),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          top: BorderSide(color: borderColor, width: 0.5),
                          left: BorderSide(color: borderColor, width: 1),
                          right: BorderSide(color: borderColor, width: 0.5),
                        )
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_drop_down, color: borderColor),
                      ),
                    ),
                  ),
                ),
                // DECIMAL DECREMENT ////////////////////////////////////////////////
                Expanded(
                  child: GestureDetector(
                    onTap: () => _updateDecimalBaseFrequency(--_baseFreqDecimal),
                    onLongPressStart: (_) => _startTimer(() => _updateDecimalBaseFrequency(--_baseFreqDecimal)),
                    onLongPressEnd: (_) => _stopTimer(),
                    child: Container(
                      padding: const EdgeInsets.all(0),
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                          top: BorderSide(color: borderColor, width: 0.5),
                          bottom: BorderSide(color: Colors.transparent, width: 0),
                          left: BorderSide(color: borderColor, width: 0.5),
                          right: BorderSide(color: borderColor, width: 1),
                        )
                      ),
                      child: const Center(
                        child: Icon(Icons.arrow_drop_down, color: borderColor),
                      ),
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
}