import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentPage extends StatefulWidget {
  final double monthlyInvestment;
  final String planDetails;
  final double returnAmount;
  final double totalAmount;
  final int duration;

  PaymentPage({
    required this.monthlyInvestment,
    required this.planDetails,
    required this.returnAmount,
    required this.totalAmount,
    required this.duration,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;
  final List<String> _paymentMethods = [
    'Google Pay',
    'Cash',
    'BHIM UPI',
    'Paytm'
  ];

  void _showPaymentSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text(
            'Your payment of ₹${widget.totalAmount.toStringAsFixed(2)} has been successfully processed.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/dope.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                color: Colors.deepPurple,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  "PAY NOW",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  margin: EdgeInsets.only(left: 10, top: 5, bottom: 10),
                  padding: EdgeInsets.all(5),
                  color: Colors.red,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "BACK",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Plan Details:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.planDetails,
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Amount:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹${widget.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Return on Investment:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹${widget.returnAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Total Amount after ${widget.duration} months:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '₹${widget.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Select method to make payment",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: _paymentMethods.map((method) {
                    return ListTile(
                      leading: Radio<String>(
                        activeColor: Colors.brown,
                        value: method,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedPaymentMethod = value;
                          });
                        },
                      ),
                      title: Text(
                        method,
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text('Pay Now'),
                onPressed: () async {
                  if (_selectedPaymentMethod == 'Cash') {
                    _showPaymentSuccessfulDialog();
                    return;
                  }

                  String? url;
                  switch (_selectedPaymentMethod) {
                    case 'Google Pay':
                      url =
                      'https://play.google.com/store/apps/details?id=com.google.android.apps.nbu.paisa.user';
                      break;
                    case 'Paytm':
                      url =
                      'https://play.google.com/store/apps/details?id=net.one97.paytm';
                      break;
                    case 'BHIM UPI':
                      url =
                      'https://play.google.com/store/apps/details?id=in.org.npci.upiapp';
                      break;
                  }

                  if (url != null && await canLaunch(url)) {
                    await launch(url);
                    _showPaymentSuccessfulDialog();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Could not launch $_selectedPaymentMethod'),
                    ));
                  }
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}