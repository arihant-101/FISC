import 'package:flutter/material.dart';
import 'portfolio_page.dart'; // Assuming the correct import path

class PortfolioValueWidget extends StatelessWidget {
  final double totalPortfolioValue;
  final double investedValue;
  final double percentageChange;

  PortfolioValueWidget({
    required this.totalPortfolioValue,
    required this.investedValue,
    required this.percentageChange,
  });

  @override
  Widget build(BuildContext context) {
    String formattedPercentage = percentageChange >= 0
        ? '+${percentageChange.toStringAsFixed(2)}%'
        : '${percentageChange.toStringAsFixed(2)}%';

    Color changeColor = percentageChange >= 0 ? Colors.green : Colors.red;

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Portfolio Overview',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PortfolioPage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward,
                    size: 30,
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16), // Increased the spacing
            ListTile(
              leading: Icon(Icons.attach_money, size: 40, color: Colors.green),
              title: Text(
                'Total Portfolio Value',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '\₹$totalPortfolioValue',
                style: TextStyle(fontSize: 24, color: Colors.green),
              ),
            ),
            Divider(color: Colors.grey),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPortfolioInfo('Invested Value', '\₹$investedValue'),
                _buildPercentageChange(formattedPercentage, changeColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioInfo(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 4), // Added slight spacing
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPercentageChange(String formattedPercentage, Color changeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Percentage Change',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 4), // Added slight spacing
        Text(
          formattedPercentage,
          style: TextStyle(fontSize: 18, color: changeColor),
        ),
      ],
    );
  }
}
