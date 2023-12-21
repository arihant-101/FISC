import 'package:flutter/material.dart';

class GoldInput extends StatefulWidget {
  @override
  _GoldInputState createState() => _GoldInputState();
}

class _GoldInputState extends State<GoldInput> {
  String selectedOption = 'Amount'; // Default selected option

  @override
  Widget build(BuildContext context) {
    return _buildGoldInvestmentInput();
  }

  Widget _buildGoldInvestmentInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Investment in Gold',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter value',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              DropdownButton<String>(
                value: selectedOption,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedOption = newValue;
                    });
                  }
                },
                items: <String>['Amount', 'Grams'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 12),
          Divider(),
        ],
      ),
    );
  }
}
