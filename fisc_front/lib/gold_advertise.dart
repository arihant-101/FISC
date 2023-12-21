import 'package:flutter/material.dart';
import 'gold_dashboard.dart';
import 'payment_page.dart';

class GoldAdvertise extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildAdvertisingCard(context); // Pass the context here
  }

  Widget _buildAdvertisingCard(BuildContext context) { // Add the BuildContext parameter here
    return Column(
      children: [
        Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.orange,
                  Colors.yellow,
                ], // Change gradient colors as needed
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enhance Your Gold Portfolio',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Invest more in gold for better returns! Choose between grams or amount to invest.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to GoldDashboard page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoldDashboard()),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the background color to green
              ),
              child: Text('Go to Gold Dashboard'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigate to PaymentPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(totalAmount: 3500)),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the background color to blue
              ),
              child: Text('Buy Now'),
            ),
          ],
        ),
      ],
    );
  }
}
