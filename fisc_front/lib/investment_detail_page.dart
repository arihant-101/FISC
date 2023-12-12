import 'dart:math';
import 'package:flutter/material.dart';
import 'payment_page.dart';

void main() {
  runApp(MaterialApp(
    home: InvestmentDetailPage(),
  ));
}

class InvestmentDetailPage extends StatefulWidget {
  @override
  _InvestmentDetailPageState createState() => _InvestmentDetailPageState();
}

class _InvestmentDetailPageState extends State<InvestmentDetailPage> {
  double monthlyInvestment = 0;
  int? duration;
  double estimatedReturn = 0;
  List<int> durationOptions = [6, 12, 36, 48, 60];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Details'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildMonthlyInvestmentInput(),
            SizedBox(height: 16),
            _buildDurationDropdown(),
            SizedBox(height: 32),
            _buildEstimatedReturnCard(),
            SizedBox(height: 32),
            _buildProceedButton(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyInvestmentInput() {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
      decoration: InputDecoration(
        labelText: 'Monthly Investment',
        labelStyle: TextStyle(fontSize: 20, color: Colors.deepPurple),
        hintText: 'Enter monthly investment amount',
        hintStyle: TextStyle(fontSize: 20, color: Colors.grey),
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.money, color: Colors.deepPurple),
      ),
      onChanged: (value) {
        setState(() {
          monthlyInvestment = double.tryParse(value) ?? 0;
          calculateEstimatedReturn();
        });
      },
    );
  }

  Widget _buildDurationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Duration (in months):',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: duration,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          items: durationOptions.map((int value) {
            return DropdownMenuItem<int>(
              value: value,
              child: Text('$value months', style: TextStyle(color: Colors.deepPurple)),
            );
          }).toList(),
          onChanged: (int? value) {
            setState(() {
              duration = value;
              calculateEstimatedReturn();
            });
          },
        ),
      ],
    );
  }

  Widget _buildEstimatedReturnCard() {
    return Card(
      color: Colors.deepPurple[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated Return:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Total Investment: ₹${(monthlyInvestment * (duration ?? 0)).toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            Text(
              'Estimated Value: ₹${estimatedReturn.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProceedButton() {
    return ElevatedButton(
      onPressed: () {
        if (monthlyInvestment <= 0) {
          _showInvalidAmountDialog(context);
        } else if (duration == null) {
          _showInvalidDurationDialog(context);
        } else {
          _showTermsAndConditionsDialog(context);
        }
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.green,
        minimumSize: Size(double.infinity, 50),
      ),
      child: Text('Proceed'),
    );
  }

  void calculateEstimatedReturn() {
    double annualRate = 5.0 / 100; // Annual interest rate (5.0%)
    double monthlyRate = annualRate / 12; // Monthly interest rate
    int months = duration ?? 0;
    double totalReturn = 0;

    for (int i = 1; i <= months; i++) {
      totalReturn += monthlyInvestment * pow(1 + monthlyRate, i - 1).toDouble();
    }

    setState(() {
      estimatedReturn = totalReturn;
    });
  }



  void _showInvalidAmountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Monthly Investment'),
          content: Text('Please enter a valid monthly investment amount greater than 0.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showInvalidDurationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Duration'),
          content: Text('Please select a valid duration.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    bool accepted = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 16),
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        '',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Checkbox(
                          value: accepted,
                          onChanged: (value) {
                            setState(() {
                              accepted = value!;
                            });
                          },
                        ),
                        Text('I accept terms and conditions'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          child: Text('Cancel/Go Back'),
                        ),
                        ElevatedButton(
                          onPressed: accepted
                              ? () {
                            Navigator.of(context).pop(); // Close the dialog
                            _proceedToPayment(context); // Navigate to the payment page
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            primary: accepted ? Colors.green : Colors.grey,
                          ),
                          child: Text('Proceed to Payment'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _proceedToPayment(BuildContext context) {
    // Add logic to navigate to the payment page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          monthlyInvestment: monthlyInvestment,
          planDetails: 'RiskLevel', // Replace with the actual risk level
          returnAmount: estimatedReturn,
          totalAmount: monthlyInvestment * (duration ?? 0) + estimatedReturn,
          duration: duration ?? 0,
        ),
      ),
    );
  }
}