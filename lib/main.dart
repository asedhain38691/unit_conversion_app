import 'package:flutter/material.dart';

void main() {
  // Entry point of the Flutter app
  runApp(const ConversionApp());
}

class ConversionApp extends StatelessWidget {
  const ConversionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter', // App title
      theme: ThemeData(primarySwatch: Colors.blue), // Primary app color theme
      home: const ConversionHomePage(), // Home screen of the app
    );
  }
}

class ConversionHomePage extends StatefulWidget {
  const ConversionHomePage({super.key});

  @override
  State<ConversionHomePage> createState() => _ConversionHomePageState();
}

class _ConversionHomePageState extends State<ConversionHomePage> {
  // Controller for the input TextField
  final TextEditingController _controller = TextEditingController();

  // Selected units for conversion
  String _fromUnit = 'Miles';
  String _toUnit = 'Kilometers';

  // Result string to display conversion
  String _result = '';

  // Distance conversion map with base unit as Kilometer
  // Key = unit name, Value = conversion factor to/from base unit
  final Map<String, double> distanceConversion = {
    'Kilometers': 1.0,   // Base unit
    'Miles': 0.621371,
    'Meters': 1000,
    'Feet': 3280.84,
  };

  // Weight conversion map with base unit as Kilogram
  final Map<String, double> weightConversion = {
    'Kilograms': 1.0,    // Base unit
    'Pounds': 2.20462,
    'Grams': 1000,
    'Ounces': 35.274,
  };

  // Current measure type: Distance or Weight
  String _measureType = 'Distance';

  // Returns the list of units depending on selected measure type
  List<String> get _unitOptions {
    if (_measureType == 'Distance') {
      return distanceConversion.keys.toList();
    } else {
      return weightConversion.keys.toList();
    }
  }

  // Converts the entered value from _fromUnit to _toUnit
  void _convert() {
    double value = double.tryParse(_controller.text) ?? 0;

    double result;
    if (_measureType == 'Distance') {
      // Conversion formula for distance
      result = value *
          distanceConversion[_toUnit]! /
          distanceConversion[_fromUnit]!;
    } else {
      // Conversion formula for weight
      result = value *
          weightConversion[_toUnit]! /
          weightConversion[_fromUnit]!;
    }

    // Update the result string in human-readable format
    setState(() {
      _result =
          '${value.toString()} $_fromUnit is ${result.toStringAsFixed(2)} $_toUnit';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Measures Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dropdown to select measure type (Distance or Weight)
            DropdownButton<String>(
              value: _measureType,
              isExpanded: true,
              items: ['Distance', 'Weight']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _measureType = val!;
                  // Reset units to default when measure type changes
                  _fromUnit = _unitOptions[0];
                  _toUnit = _unitOptions[1];
                });
              },
            ),
            const SizedBox(height: 16),

            // TextField to enter value to convert
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter value',
              ),
            ),
            const SizedBox(height: 16),

            // Row containing "From" and "To" unit dropdowns
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'From',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      DropdownButton<String>(
                        value: _fromUnit,
                        isExpanded: true,
                        items: _unitOptions
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _fromUnit = val!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'To',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      DropdownButton<String>(
                        value: _toUnit,
                        isExpanded: true,
                        items: _unitOptions
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _toUnit = val!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Button to trigger conversion
            ElevatedButton(
              onPressed: _convert,
              child: const Text('Convert'),
            ),
            const SizedBox(height: 16),

            // Display the result
            Text(
              _result,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}