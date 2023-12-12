import 'package:flutter/material.dart';
import 'investment_detail_page.dart';
import 'portfolio_page.dart';
import 'transaction_screen.dart';
import 'setting_screen.dart';
import 'gold_dashboard.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedTransaction;
  bool showRiskOptions = false;
  bool showGoldOptions = false;
  bool minimizeDropdown = false;
  List<bool> isSelected = [false, false];

  double calculateTotalPortfolioValue() {
    // Replace this with your actual logic to compute the total portfolio value
    // For example, fetch data from your portfolio and calculate the total value
    return 7200.0; // Sample value, replace with your actual calculation
  }

  @override
  Widget build(BuildContext context) {
    Color hunterGreen = Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: hunterGreen,
        elevation: 0,
        title: Text(
          'FISC',
          style: TextStyle(fontSize: 32, color: Colors.green),
        ),
        centerTitle: true,
        // Add this line to center the title
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.red,
              ),
              onPressed: () {
                // Add your notification action here
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('John Doe'),
                accountEmail: Text('john.doe@example.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
                  // Placeholder for user's profile image
                  // You can replace this with an actual user image
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.green),
                title: Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
              ),

              Divider(),
              ListTile(
                leading:
                    Icon(Icons.account_balance_wallet, color: Colors.green),
                title: Text('Portfolio'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PortfolioPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.trending_up, color: Colors.green),
                title: Text('Investments Details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InvestmentDetailPage(),
                    ),
                  );
                },
              ),
              // Add more list tiles as needed
              Divider(),
              ListTile(
                leading: Icon(Icons.help, color: Colors.green),
                title: Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                  // Add action for Help & Support
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.green),
                title: Text('Sign Out'),
                onTap: () {
                  Navigator.pop(context);
                  // Add action for Sign Out
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPortfolioValue(),
              _buildToggleBar(context),
              if (showRiskOptions) _buildRiskOptions(),
              if (showGoldOptions) _buildGoldOptions(),
              _buildUpcomingTransactionCard(context),
              _buildBasicTutorialCard(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPortfolioValue() {
    double totalPortfolioValue = calculateTotalPortfolioValue();
    double investedValue = 6000.0;
    double percentageChange =
        ((totalPortfolioValue - investedValue) / investedValue) * 100;
    String percentageText = percentageChange >= 0
        ? '+${percentageChange.toStringAsFixed(2)}%'
        : '${percentageChange.toStringAsFixed(2)}%';

    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.5),
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
                    fontSize: 20, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Redirect to PortfolioPage upon touching the icon
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PortfolioPage(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.arrow_forward, // Add any desired icon here
                    size: 30,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
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
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPortfolioInfo('Invested Value', '\₹$investedValue'),
                _buildPortfolioInfo('Change', percentageText),
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
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: title == 'Change'
                ? (value.contains('+') ? Colors.green : Colors.red)
                : Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: ToggleButtons(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Invest in Plan',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              'Invest in Gold',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
        isSelected: isSelected,
        onPressed: (int newIndex) {
          setState(() {
            if (isSelected[newIndex]) {
              // If the same toggle button is pressed again, minimize options
              showRiskOptions = false;
              showGoldOptions = false;
            } else {
              isSelected = isSelected.map((e) => false).toList();
              isSelected[newIndex] = true;

              showRiskOptions = (newIndex == 0);
              showGoldOptions = (newIndex == 1);
            }
          });
        },
        borderRadius: BorderRadius.circular(30),
        selectedColor: Colors.black,
        fillColor: Colors.green,
        borderColor: Colors.blueAccent,
        borderWidth: 2,
        selectedBorderColor: Colors.black,
        splashColor: Colors.blue, // Add a splash color on tap
      ),
    );
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
            SizedBox(height: 2),
            Text(
              'Due Date: 15th Dec 2023',
              style: TextStyle(color: hunterGreen),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    // Implement Pay Now functionality
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: hunterGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Pay Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: hunterGreen),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            TransactionPage(), // Navigate to TransactionPage
                      ),
                    );
                  },
                  child: Text(
                    'Check Transactions',
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
    // Simulated transaction details, replace this with actual data based on the selected transaction
    String transactionTitle = 'Monthly Subscription';
    String transactionAmount = '\$150';
    String transactionType = 'Subscription Payment';
    String transactionStatus = 'Pending';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTransactionDetailItem('Title', transactionTitle),
        _buildTransactionDetailItem('Amount', transactionAmount),
        _buildTransactionDetailItem('Type', transactionType),
        _buildTransactionDetailItem('Status', transactionStatus),
      ],
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

  Widget _buildBasicTutorialCard(BuildContext context) {
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
                  color: hunterGreen),
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
                color: color, fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget _buildRiskOptions() {
    return Column(
      children: [
        _buildRiskOptionTile(
          'No Risk',
          Colors.green,
          'View More',
          'Buy Now',
          'No risk is associated with this investment level.',
        ),
        _buildRiskOptionTile(
          'Low Risk',
          Colors.blueGrey,
          'View More',
          'Buy Now',
          'Low risk investments offer moderate returns with minimal volatility.',
        ),
        _buildRiskOptionTile(
          'Medium Risk',
          Colors.orange,
          'View More',
          'Buy Now',
          'Medium risk investments provide a balance between risk and return.',
        ),
        _buildRiskOptionTile(
          'High Risk',
          Colors.red,
          'View More',
          'Buy Now',
          'High risk investments offer potentially higher returns but come with increased volatility.',
        ),
      ],
    );
  }

  Widget _buildRiskOptionTile(
    String riskLevel,
    Color color,
    String viewMoreText,
    String buyNowText,
    String description,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          riskLevel,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        collapsedTextColor: Colors.black,
        collapsedIconColor: color,
        childrenPadding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              _showMoneyAllocationDialog(context, riskLevel);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showMoneyAllocationDialog(context, riskLevel);
                        },
                        child: Text(
                          viewMoreText,
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: color,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Redirect to PortfolioPage upon touching the icon
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvestmentDetailPage(),
                            ),
                          );
                        },
                        child: Text(
                          buyNowText,
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: color,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoneyAllocationDialog(BuildContext context, String riskLevel) {
    String equityPercentage;
    String fixedDepositPercentage;

    switch (riskLevel) {
      case 'No Risk':
        equityPercentage = '100%';
        fixedDepositPercentage = '0%';
        break;
      case 'Low Risk':
        equityPercentage = '80%';
        fixedDepositPercentage = '20%';
        break;
      case 'Medium Risk':
        equityPercentage = '60%';
        fixedDepositPercentage = '40%';
        break;
      case 'High Risk':
        equityPercentage = '40%';
        fixedDepositPercentage = '60%';
        break;
      default:
        equityPercentage = '0%';
        fixedDepositPercentage = '0%';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: dialogContent(
              context, riskLevel, equityPercentage, fixedDepositPercentage),
        );
      },
    );
  }

  Widget dialogContent(
    BuildContext context,
    String riskLevel,
    String equityPercentage,
    String fixedDepositPercentage,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    '$riskLevel Money Allocation',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Fixed Deposits: $equityPercentage',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Text(
                      'Stocks: $fixedDepositPercentage',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 40.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoldOptions() {
    return SizedBox(
      height: 250,
      child: ListView(
        children: [
          _buildGoldOptionTile(
            'Buy Gold',
            Colors.orange,
            'View Gold Prices',
            'Buy Now',
            'Purchase gold as part of your investment portfolio.',
          ),
          _buildGoldOptionTile(
            'Sell Gold',
            Colors.red,
            'View Gold Prices',
            'Sell Now',
            'Sell your gold investments.',
          ),
          // Add more gold-related options as needed
        ],
      ),
    );
  }

  Widget _buildGoldOptionTile(
    String option,
    Color color,
    String viewPricesText,
    String actionText,
    String description,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        title: Text(
          option,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        collapsedTextColor: Colors.black,
        collapsedIconColor: color,
        childrenPadding: EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Redirect to Gold Dashboard upon touching the "View Gold Prices" button
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GoldDashboard(), // Navigate to GoldDashboard
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Redirect to Gold Dashboard upon touching the "View Gold Prices" button
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GoldDashboard(), // Navigate to GoldDashboard
                            ),
                          );
                        },
                        child: Text(
                          viewPricesText,
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: color,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement buy/sell functionality
                        },
                        child: Text(
                          actionText,
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: color,
                          padding: EdgeInsets.symmetric(horizontal: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
