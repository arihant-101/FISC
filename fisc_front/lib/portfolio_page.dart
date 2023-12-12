import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PortfolioPage(),
  ));
}

class PortfolioPage extends StatefulWidget {
  @override
  _PortfolioPageState createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  final List<Map<String, dynamic>> portfolioData = [
    {
      'accountNo': 'PL001',
      'initiationDate': '2021-01-01',
      'investedAmount': '1000',
      'type': 'Plan',
    },
    {
      'accountNo': 'PL002',
      'initiationDate': '2021-03-10',
      'investedAmount': '500',
      'type': 'Gold',
    },
    {
      'accountNo': 'B789',
      'initiationDate': '2021-06-15',
      'investedAmount': '2000',
      'type': 'Plan',
    },
    {
      'accountNo': 'G101',
      'initiationDate': '2021-07-21',
      'investedAmount': '250',
      'type': 'Gold',
    },
    {
      'accountNo': 'C111',
      'initiationDate': '2021-05-10',
      'investedAmount': '1500',
      'type': 'Plan',
    },
    {
      'accountNo': 'G121',
      'initiationDate': '2021-09-05',
      'investedAmount': '750',
      'type': 'Gold',
    },
  ];

  Map<String, List<Map<String, dynamic>>> getGroupedData() {
    Map<String, List<Map<String, dynamic>>> groupedData = {};
    for (var data in portfolioData) {
      if (!groupedData.containsKey(data['type'])) {
        groupedData[data['type']] = [];
      }
      groupedData[data['type']]!.add(data);
    }
    return groupedData;
  }

  double getCurrentValue(double investedAmount) {
    return investedAmount * 1.2; // Assuming a 20% increase for the current value
  }

  IconData getIndicatorIcon(double currentValue, double investedAmount) {
    return currentValue >= investedAmount ? Icons.arrow_upward : Icons.arrow_downward;
  }

  Color getIndicatorColor(double currentValue, double investedAmount) {
    return currentValue >= investedAmount ? Colors.green : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, List<Map<String, dynamic>>> groupedData = getGroupedData();

    return DefaultTabController(
      length: groupedData.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Portfolio'),
          backgroundColor: Colors.black,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: groupedData.keys.map((type) => Tab(text: type)).toList(),
          ),
        ),
        body: TabBarView(
          children: groupedData.keys.map((type) {
            List<Map<String, dynamic>> sortedData = groupedData[type]!;
            sortedData.sort((a, b) => a['initiationDate'].compareTo(b['initiationDate']));

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTotalValueCard(
                    'Total $type Value',
                    getTotalInvested(sortedData),
                    getTotalCurrentValue(sortedData),
                  ),
                  SizedBox(height: 10),
                  ...sortedData.map((record) => _buildCard(record)).toList(),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTotalValueCard(String title, double investedAmount, double currentValue) {
    double percentageChange = ((currentValue - investedAmount) / investedAmount) * 100;

    return Card(
      color: Colors.blueAccent,
      margin: EdgeInsets.all(20),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '$title',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildValueColumn('Invested', '₹${investedAmount.toStringAsFixed(2)}'),
                _buildValueColumn('Current Value', '₹${currentValue.toStringAsFixed(2)}'),
              ],
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Percentage Change: ',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  '${percentageChange.toStringAsFixed(2)}%',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueColumn(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }


  double getTotalInvested(List<Map<String, dynamic>> data) {
    return data.fold(0, (total, record) => total + double.parse(record['investedAmount']));
  }

  double getTotalCurrentValue(List<Map<String, dynamic>> data) {
    double totalCurrentValue = 0;
    for (var record in data) {
      double investedAmount = double.parse(record['investedAmount']);
      totalCurrentValue += getCurrentValue(investedAmount);
    }
    return totalCurrentValue;
  }


  Widget _buildHighClassValueWidget(double value) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [Colors.yellow, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        '₹${(value * 74.5).toStringAsFixed(2)}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> record) {
    double investedAmount = double.parse(record['investedAmount']);
    double currentValue = getCurrentValue(investedAmount);
    bool isPositiveGrowth = currentValue >= investedAmount;

    DateTime initiationDate = DateTime.parse(record['initiationDate']);
    DateTime currentDate = DateTime.now();
    int monthsInvested = currentDate.month - initiationDate.month + (currentDate.year - initiationDate.year) * 12;

    double percentageChange = ((currentValue - investedAmount) / investedAmount) * 100;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          ExpansionTile(
            initiallyExpanded: false,
            leading: Icon(
              isPositiveGrowth ? Icons.trending_up : Icons.trending_down,
              color: isPositiveGrowth ? Colors.green : Colors.red,
              size: 36,
            ),
            title: Text(
              '${record['type']} ${record['accountNo']}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              'Invested: ₹${record['investedAmount']} on ${record['initiationDate']}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Additional Details:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Current Value: ₹${currentValue.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Percentage Change: ${percentageChange.toStringAsFixed(2)}%',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    Text(
                      'Months Invested: $monthsInvested',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                    // Add more details here as needed
                  ],
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }



}
