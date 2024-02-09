import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'user.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final String duration;
  final String frequency;

  PaymentPage({
    required this.totalAmount,
    required this.duration,
    required this.frequency,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'name': 'Google Pay',
      'url':
          'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user',
      'image': 'assets/pngwing.com.png', // Replace with your image file
    },
    {
      'name': 'BHIM UPI',
      'url': 'https://play.google.com/store/apps/details?id=in.org.npci.upiapp',
      'image': 'assets/bhim-upi-icon.png',
    },
    {
      'name': 'Paytm',
      'url': 'https://play.google.com/store/apps/details?id=net.one97.paytm',
      'image': 'assets/paytm.png',
    },
  ];

  void _showPaymentSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text(
          'Your payment of ₹${widget.totalAmount.toStringAsFixed(2)} has been successfully processed.',
        ),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  int investid = 0;
  Future<void> _createInvestmentAndTransaction() async {
    try {
      // Step 1: Create Investment
      await _createInvestment();

      // Ensure the investment creation was successful
      // Step 2: Create Transaction
      await _createTransaction(
          investid); // Replace 'investmentId' with the actual field name

      // Step 3: Update Investment Status
      await _updateInvestmentStatus(
          investid); // Replace 'investmentId' with the actual field name

      // Show payment successful dialog
      _showPaymentSuccessfulDialog();
    } catch (error) {
      // Handle any errors that occurred during the process
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred. Please try again.'),
      ));
    }
  }

  Future<void> _createInvestment() async {
    try {
      // Prepare the JSON payload
      final Map<String, dynamic> requestBody = {
        'planId': 1, // Replace with the actual plan ID
        'phoneNo':
            loggedInUser?.phoneNo, // Replace with the user's phone number
        'amount': widget.totalAmount,
        'monthsLeft': widget.duration,
        'DurationLeft': widget.duration,
        'CurrentAmount': widget.totalAmount,
        'status': "Active",
        'frequency': widget.frequency,
      };

      // Convert the map to JSON
      final String jsonBody = json.encode(requestBody);

      // Make an API request to create a new investment
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/investments'),
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        // Investment created successfully
        final Map<String, dynamic> investmentResponse =
            json.decode(response.body);

        final int InvestmentId = investmentResponse['InvestmentId'];
        investid = InvestmentId;

        print('Investment created successfully');
      } else {
        // Handle error if the investment creation fails
        print('Error creating investment: ${response.body}');
      }
    } catch (error) {
      // Handle any exception that may occur during the API request
      print('Error creating investment: $error');
    }
  }

  Future<void> _createTransaction(int investid) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/api/create-transaction'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'InvestmentId': investid,
          'PhoneNo':
              loggedInUser?.phoneNo, // Replace with the user's phone number
          'Amount': widget.totalAmount,
          'Status':
              "pending", // You might want to adjust this based on your logic
          'GeneratedAt': DateTime.now().toIso8601String(),
          'DueDate': DateTime.now().toIso8601String(),
        }),
      );

      if (response.statusCode == 200) {
        // Transaction created successfully
        print('Transaction created successfully');
      } else {
        // Handle error if transaction creation fails
        print('Error creating transaction: ${response.body}');
      }
    } catch (error) {
      // Handle any exception that may occur during the API request
      print('Error creating transaction: $error');
    }
  }

  Future<void> _updateInvestmentStatus(int investmentId) async {
    try {
      final response = await http.patch(
        Uri.parse('http://10.0.2.2:3000/api//investments/$investid'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'Status': "Active"}), // Set the desired status
      );

      if (response.statusCode == 200) {
        print('Investment status updated successfully');
      } else {
        print('Failed to update investment status: ${response.statusCode}');
        // Handle error if needed
      }
    } catch (error) {
      print('Error updating investment status: $error');
      // Handle error if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Payment'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Investment Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Duration: ${widget.duration} months',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Frequency: ${widget.frequency}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Select a payment method",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: _paymentMethods.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = _paymentMethods[index]['name'];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 20,
                      ),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Image.asset(
                            _paymentMethods[index]['image'],
                            height: 50, // Adjust the size as needed
                            width: 50, // Adjust the size as needed
                          ),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text(
                              _paymentMethods[index]['name'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          trailing: _selectedPaymentMethod ==
                                  _paymentMethods[index]['name']
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  // Call the function to create investments and transactions
                  await _createInvestmentAndTransaction();
                },
                child: Text(
                  'Pay Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
