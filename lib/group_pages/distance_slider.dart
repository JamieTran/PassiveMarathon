import 'package:flutter/material.dart';

class DistanceSlider extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _DistanceSliderWidgetState();
  }
}
    
class _DistanceSliderWidgetState extends State{
  double _value = 42;

  @override
  Widget build(BuildContext context) {
    return Slider(
            value: _value.toDouble(),
            min: 0.1,
            max: 42,
            divisions: 420,
            activeColor: Colors.red,
            inactiveColor: Colors.black,
            label: _value.toStringAsFixed(1) + " kms",
            onChanged: (double newValue) {
              setState(() {
                _value = newValue;
              });
            },
            semanticFormatterCallback: (double newValue) {
              return '${newValue.round()} dollars';
            }
        );
  }

}