import 'package:drone_factory/utils/constants.dart';
import 'package:flutter/material.dart';

class BaseFrequencyProvider extends ChangeNotifier {
  double _baseFrequency = AudioConstants.defaultFrequency;
  
  double get baseFrequency => _baseFrequency;

  void updateBaseFrequency(double newFrequency) {
    _baseFrequency = newFrequency;
    notifyListeners();
  }
}