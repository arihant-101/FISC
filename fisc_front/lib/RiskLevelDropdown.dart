import 'package:flutter/material.dart';

import 'payment_page.dart';

class RiskLevel extends StatefulWidget {
  @override
  _RiskLevelState createState() => _RiskLevelState();
}

class _RiskLevelState extends State<RiskLevel> {
  String? selectedRiskLevel;

  @override
  Widget build(BuildContext context) {
    return _buildRiskLevelDropdown();
  }

  Widget _buildRiskLevelDropdown() {
    List<String> riskLevelOptions = ['No', 'Low', 'Moderate', 'High'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Risk Level',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 36,
                  elevation: 8,
                  hint: Text('Select Risk Level',
                      style: TextStyle(color: Colors.black)),
                  value: selectedRiskLevel,
                  items: riskLevelOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedRiskLevel = newValue;
                      _showRiskPlanDetails(newValue);
                    });
                  },
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 12), // Space before the 'Invest Now' button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(totalAmount: 4000),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green, // Set the background color to green
            ),
            child: Text('Invest Now'),
          ),
        ],
      ),
    );
  }

  void _showRiskPlanDetails(String? riskLevel) {
    String planDetails = '';

    switch (riskLevel) {
      case 'No':
        planDetails =
        'For no risk plan:\n100% will be invested in deposits, 0% in mutual funds.';
        break;
      case 'Low':
        planDetails =
        'For low risk plan:\n80% will be invested in deposits, 20% in mutual funds.';
        break;
      case 'Moderate':
        planDetails =
        'For moderate risk plan:\n60% will be invested in deposits, 40% in mutual funds.';
        break;
      case 'High':
        planDetails =
        'For high risk plan:\n40% will be invested in deposits, 60% in stocks.';
        break;
      default:
        planDetails = 'Select a risk level to view investment details.';
        break;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Investment Plan Details',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  planDetails,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
