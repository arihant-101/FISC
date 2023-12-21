import 'package:flutter/material.dart';

class TutorialCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildTutorialCard();
  }

  Widget _buildTutorialCard() {
    Color hunterGreen = Colors.green;
    return Card(
      elevation: 4,
      shadowColor: hunterGreen.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Basic Tutorial',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: hunterGreen,
              ),
            ),
            SizedBox(height: 4),
            SizedBox(
              height: 150,
              child: PageView(
                children: [
                  _buildSlideContent(
                    'Welcome to Fisc App!',
                    'This is a basic tutorial on how to use the app. You can navigate through different sections like Investments, Portfolio, and Transactions using the buttons provided.',
                    hunterGreen,
                  ),
                  _buildSlideContent(
                    'Investment Hub',
                    'Explore investment options and manage your portfolio effectively in the Investment Hub.',
                    hunterGreen,
                  ),
                  _buildSlideContent(
                    'Transaction Management',
                    'Keep track of your transactions and upcoming payments for better financial planning.',
                    hunterGreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlideContent(String title, String content, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            content,
            textAlign: TextAlign.center,
            style: TextStyle(color: color, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
