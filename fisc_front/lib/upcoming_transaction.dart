import 'package:flutter/material.dart';
import 'transaction_screen.dart';

class UpcomingTransaction extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UpcomingTransactionState();
}

class _UpcomingTransactionState extends State<UpcomingTransaction> {
  String? selectedTransaction;

  @override
  Widget build(BuildContext context) {
    return _buildUpcomingTransactionCard(context);
  }

  Widget _buildUpcomingTransactionCard(BuildContext context) {
    Color hunterGreen = Colors.black;
    return Card(
      elevation: 4,
      shadowColor: hunterGreen.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upcoming Transaction',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: hunterGreen,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Due Date: 15th Dec 2023',
              style: TextStyle(color: hunterGreen),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: hunterGreen),
                  onPressed: () {
                    // Implement Pay Now functionality
                    // For now, just navigate to previous transactions
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Pay Now',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: hunterGreen),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Previous Transactions',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(hunterGreen),
              value: 0.8,
            ),
            SizedBox(height: 20),
            Text(
              'Transaction Details:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: hunterGreen,
              ),
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedTransaction,
              hint: Text('Select Transaction'),
              items: ['Transaction 1', 'Transaction 2', 'Transaction 3']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedTransaction = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            if (selectedTransaction != null)
              _buildTransactionDetails(selectedTransaction!),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(String selectedTransaction) {
    // Simulated transaction details
    Map<String, String> transactionDetails = {
      'Title': 'Monthly Subscription',
      'Amount': '\$150',
      'Type': 'Subscription Payment',
      'Status': 'Pending',
      // Add more details if needed
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: transactionDetails.entries.map((entry) {
        return _buildTransactionDetailItem(entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildTransactionDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label + ':',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
