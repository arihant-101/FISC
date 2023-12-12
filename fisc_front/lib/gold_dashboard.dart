import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    home: GoldDashboard(),
  ));
}

class GoldDashboard extends StatefulWidget {
  @override
  _GoldDashboardState createState() => _GoldDashboardState();
}

class _GoldDashboardState extends State<GoldDashboard> {
  String _goldPrice = '₹1125 per gram';
  String _lastUpdated = '11th December 2023';
  bool _isRefreshing = false;
  TextEditingController _controller = TextEditingController();
  String _selectedConversion = 'Rupees to Grams';
  double _result = 0.0;

  final List<Widget> _advertisementCards = [
    AdvertisementCard(
      color: Colors.orangeAccent,
      title: 'Buy Gold Now!',
      description: 'Get your hands on gold while the prices are soaring!',
      icon: Icons.shopping_cart,
    ),
    AdvertisementCard(
      color: Colors.blueAccent,
      title: 'Sell Gold Today!',
      description: 'Trade your gold for great returns. Sell now!',
      icon: Icons.attach_money,
    ),
    AdvertisementCard(
      color: Colors.greenAccent,
      title: 'Invest in Gold',
      description: 'Diversify your portfolio. Invest in gold today!',
      icon: Icons.bar_chart,
    ),
  ];

  double ouncesToGrams(double ounces) {
    return ounces * 28.3495;
  }

  void _updateGoldPrice() {
    setState(() {
      final random = Random();
      final newPrice = (1000 + random.nextInt(500)).toDouble();
      _goldPrice = '₹${newPrice.toStringAsFixed(2)} per gram';
      _lastUpdated = DateTime.now().toString().split('.')[0];
    });
  }

  Future<void> _refreshPrices() async {
    setState(() {
      _isRefreshing = true;
    });
    await Future.delayed(Duration(seconds: 2)); // Simulating a delay
    _updateGoldPrice();
    setState(() {
      _isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Prices Refreshed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _convertValue(String value) {
    setState(() {
      double inputValue = double.tryParse(value) ?? 0.0;
      if (_selectedConversion == 'Rupees to Grams') {
        _result = inputValue / double.parse(_goldPrice.split('₹')[1]);
      } else {
        _result = inputValue * double.parse(_goldPrice.split('₹')[1]);
      }
    });
  }

  bool _isConverterExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Gold Dashboard'),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: _advertisementCards.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: _advertisementCards[index],
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Gold Price Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Gold Price:',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        _goldPrice,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Gold Price in Grams:',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        '${ouncesToGrams(1125).toStringAsFixed(2)} grams',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(),
                    ListTile(
                      title: Text(
                        'Last Updated:',
                        style: TextStyle(fontSize: 18),
                      ),
                      trailing: Text(
                        _lastUpdated,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ExpansionTile(
                      initiallyExpanded: false,
                      title: Text(
                        'Converter',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      onExpansionChanged: (expanded) {
                        setState(() {
                          _isConverterExpanded = expanded;
                        });
                      },
                      children: [
                        SizedBox(height: 10),
                        DropdownButton<String>(
                          value: _selectedConversion,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.black),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedConversion = newValue!;
                            });
                          },
                          items: <String>[
                            'Rupees to Grams',
                            'Grams to Rupees',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: _selectedConversion == 'Rupees to Grams'
                                ? 'Enter Rupees'
                                : 'Enter Grams',
                          ),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _convertValue(_controller.text);
                          },
                          child: Text('Convert'),
                        ),
                        SizedBox(height: 10),
                        if (_isConverterExpanded)
                          Text(
                            'Result: $_result',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isRefreshing ? null : _refreshPrices,
              icon: _isRefreshing
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    )
                  : Icon(Icons.refresh),
              label: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Refresh Prices',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 4,
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class AdvertisementCard extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final IconData icon;

  const AdvertisementCard({
    required this.color,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 300,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Stack(
          children: [
            Positioned(
              right: 10,
              bottom: 10,
              child: Icon(
                icon,
                size: 40,
                color: Colors.white.withOpacity(0.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
