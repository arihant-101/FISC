import 'package:flutter/material.dart';
import 'payment_page.dart';

class GoldInput extends StatefulWidget {
  @override
  _GoldInputState createState() => _GoldInputState();
}

class _GoldInputState extends State<GoldInput> {
  String _selectedOption = 'Amount'; // Default selected option
  String _goldPrice = '₹1125 per gram'; // Sample gold price
  String _lastUpdated = '11th December 2023'; // Sample last updated date
  bool _isRefreshing = false;
  TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'Rupees to Grams'; // Default conversion type
  double _result = 0.0;
  bool _isValid = true;

  @override
  Widget build(BuildContext context) {
    return _buildGoldInvestmentInput();
  }

  Widget _buildGoldInvestmentInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Investment in Gold',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter value',
              errorText: _isValid ? null : 'Enter a valid number',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (_) {
              setState(() {
                _isValid = true; // Reset validation on change
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Value cannot be empty';
              }
              if (double.tryParse(value) == null) {
                return 'Enter a valid number';
              }
              return null;
            },
          ),
          SizedBox(height: 12),
          DropdownButton<String>(
            value: _selectedConversion,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedConversion = newValue;
                  _controller
                      .clear(); // Clear the value when the conversion type changes
                  _result = 0.0; // Reset the result
                });
              }
            },
            items: <String>['Rupees to Grams', 'Grams to Rupees']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _performConversion();
              });
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Change button color to green
            ),
            child:
                _isRefreshing ? CircularProgressIndicator() : Text('Convert'),
          ),
          SizedBox(height: 12),
          Text(
            'Gold Price: $_goldPrice\nLast Updated: $_lastUpdated',
            textAlign: TextAlign.center,
          ),
          Divider(),
          Text(
            'Result: $_result',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(
                          totalAmount: _result,
                          duration: "infinte",
                          frequency: "one-time",
                        )), // Navigate to PaymentPage
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Change button color to green
            ),
            child: Text('Buy Now'),
          ),
        ],
      ),
    );
  }

  void _performConversion() {
    double? inputValue = double.tryParse(_controller.text);

    if (inputValue != null) {
      setState(() {
        _isValid = true;
        if (_selectedConversion == 'Rupees to Grams') {
          _result = inputValue / 1125; // Assuming 1125 rupees per gram
        } else {
          _result = inputValue * 1125; // Assuming 1125 rupees per gram
        }
      });
    } else {
      setState(() {
        _isValid = false; // Set validation error if the input is invalid
      });
    }
  }
}
