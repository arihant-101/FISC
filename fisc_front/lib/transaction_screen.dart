import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      primarySwatch: Colors.green,
    ),
    home: TransactionPage(),
  ));
}

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Plan> plans = [
    Plan(id: 'PL001', riskLevel: RiskLevel.High),
    Plan(id: 'PL002', riskLevel: RiskLevel.Moderate),
  ];

  List<Transaction> transactions = [
    Transaction(
        id: 'T001', type: TransactionType.Plan, amount: 5000.0, planId: 'PL001'),
    Transaction(
        id: 'T002', type: TransactionType.Plan, amount: 3000.0, planId: 'PL001'),
    Transaction(
        id: 'T003', type: TransactionType.Gold, amount: 200.0, marketRate: 55.0),
    Transaction(
        id: 'T004', type: TransactionType.Plan, amount: 7000.0, planId: 'PL002'),
    Transaction(
        id: 'T005', type: TransactionType.Plan, amount: 4000.0, planId: 'PL002'),
    Transaction(
        id: 'T006', type: TransactionType.Gold, amount: 150.0, marketRate: 60.0),
    Transaction(
        id: 'T007', type: TransactionType.Plan, amount: -1000.0, planId: 'PL001'), // Previous
    Transaction(
        id: 'T008', type: TransactionType.Plan, amount: -2500.0, planId: 'PL002'), // Previous
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        backgroundColor: Colors.green,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Plan',
              icon: Icon(Icons.account_balance_wallet),
            ),
            Tab(
              text: 'Gold',
              icon: Icon(Icons.monetization_on),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlanTransactionSection(),
          _buildGoldTransactionSection(),
        ],
      ),
    );
  }

  Widget _buildPlanTransactionSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildTransactionSection(
            title: 'Previous Transactions',
            transactions: transactions
                .where((t) => t.type == TransactionType.Plan && t.amount < 0)
                .toList(),
          ),
          SizedBox(height: 20.0),
          _buildTransactionSection(
            title: 'Upcoming Transactions',
            transactions: transactions
                .where((t) => t.type == TransactionType.Plan && t.amount > 0)
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldTransactionSection() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: _buildTransactionSection(
        title: 'Gold Transactions',
        transactions: transactions
            .where((t) => t.type == TransactionType.Gold)
            .toList(),
      ),
    );
  }

  Widget _buildTransactionSection(
      {required String title, required List<Transaction> transactions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ),
        for (var transaction in transactions) ...[
          SizedBox(height: 20.0),
          _buildTransactionCard(transaction),
        ],
      ],
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    return Card(
      elevation: 6.0,
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${DateTime.now().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text(
                'Transaction ID: ${transaction.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: _buildTransactionDetails(transaction),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetails(Transaction transaction) {
    if (transaction.type == TransactionType.Plan) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Plan ID: ${transaction.planId ?? 'N/A'}'),
          Text(
            'Amount: ₹${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Risk Level: ${transaction.planId != null ? getRiskLevel(transaction.planId!) : 'N/A'}',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amount: ₹${transaction.amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            'Market Rate: ${transaction.marketRate ?? 'N/A'} per 10g',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }
  }

  RiskLevel getRiskLevel(String planId) {
    var plan = plans.firstWhere((p) => p.id == planId);
    return plan.riskLevel;
  }
}

class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String? planId;
  final double? marketRate;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    this.planId,
    this.marketRate,
  });
}

class Plan {
  final String id;
  final RiskLevel riskLevel;

  Plan({
    required this.id,
    required this.riskLevel,
  });
}

enum TransactionType { Plan, Gold }

enum RiskLevel { Low, Moderate, High }
