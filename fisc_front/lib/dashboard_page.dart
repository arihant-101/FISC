import 'dart:math';
import 'package:flutter/material.dart';
import 'payment_page.dart';
import 'GoldInvestmentInput.dart';
import 'kyc1.dart';
import 'upcoming_transaction.dart';
import 'portfolio_page.dart';
import 'setting_screen.dart';
import 'portfolio_value_widget.dart';
import 'tutorial_card.dart';
import 'user.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedTransaction;
  String? selectedFrequency; // Variable to store selected frequency
  String? selectedDuration; // Variable to store selected duration
  String? selectedRiskLevel;
  double estimatedReturn = 0.0;
  bool minimizeDropdown = false;
  List<bool> isSelected = [false, false];
  double calculateTotalPortfolioValue() {
    return 7200.0; // Sample value, replace with your actual calculation
  }

  TextEditingController initialAmountController = TextEditingController();
  double initialamount = 0;

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
                accountName: Text(loggedInUser?.name ?? ''),
                accountEmail: Text(loggedInUser?.phoneNo ?? ''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.black,
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
              Divider(),
              ListTile(
                leading: Icon(Icons.help, color: Colors.green),
                title: Text('Help & Support'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.green),
                title: Text('Sign Out'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.add_task_sharp, color: Colors.green),
                title: Text('KYC'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KYC1Page(),
                    ),
                  );
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
              PortfolioValueWidget(
                totalPortfolioValue: calculateTotalPortfolioValue(),
                investedValue:
                    6000.0, // Replace with your actual invested value
                percentageChange:
                    ((calculateTotalPortfolioValue() - 6000.0) / 6000.0) * 100,
              ),
              _buildToggleBar(context),
              UpcomingTransaction(),
              TutorialCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ToggleButtons(
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
                  minimizeDropdown = true;
                  isSelected[newIndex] = false;
                } else {
                  minimizeDropdown = false;
                  isSelected = isSelected.map((e) => false).toList();
                  isSelected[newIndex] = true;
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
          if (!minimizeDropdown &&
              isSelected[
                  0]) // Show options only if "Invest in Plan" is selected and not minimized
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildInitialAmountInput(),
                _buildFrequencyDropdown(),
                _buildDurationDropdown(),
                _buildROI(),
                _buildTotalAmountAfterDuration(
                    initialamount,
                    selectedFrequency ?? '',
                    int.tryParse(selectedDuration ?? '0') ?? 0,
                    4.0),
                _buildProfitAfterDuration(
                    initialamount,
                    selectedFrequency ?? '',
                    int.tryParse(selectedDuration ?? '0') ?? 0,
                    4.0),
              ],
            ),
          if (!minimizeDropdown &&
              isSelected[
                  1]) // Show options only if "Invest in Gold" is selected and not minimized
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GoldInput(), // New widget for investing in gold
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildROI() {
    double staticROI = 4.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12),
        Text(
          'ROI %',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          '$staticROI%',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 12),
        Divider(),
      ],
    );
  }

  Widget _buildTotalAmountAfterDuration(
      double principal, String frequency, int duration, double roi) {
    double totalReturn = principal;
    double compoundAmount = principal;
    double repeatingContribution = principal;
    double compoundFrequency = 0;

    if (frequency == 'Daily') {
      double dailyRate = (roi / 100) / 365;
      compoundFrequency = (365 / 12);
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + dailyRate) + repeatingContribution;
      }
      totalReturn = compoundAmount - repeatingContribution;
    } else if (frequency == 'Weekly') {
      double weeklyRate = (roi / 100) / 52;
      compoundFrequency = (52 / 12);
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + weeklyRate) + repeatingContribution;
      }
      totalReturn = compoundAmount - repeatingContribution;
    } else if (frequency == 'Monthly') {
      double monthlyRate = (roi / 100) / 12;
      compoundFrequency = 1;
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + monthlyRate) + repeatingContribution;
      }
      totalReturn = compoundAmount - repeatingContribution;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12),
        Text(
          'Total Amount After $duration Months',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          '₹ ${totalReturn.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 12),
        Divider(),
      ],
    );
  }

  Widget _buildProfitAfterDuration(
      double principal, String frequency, int duration, double roi) {
    double totalReturn = principal;
    double compoundAmount = principal;
    double repeatingContribution = principal;
    double compoundFrequency = 0;

    if (frequency == 'Daily') {
      double dailyRate = (roi / 100) / 365;
      compoundFrequency = (365 / 12);
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + dailyRate) + repeatingContribution;
      }
      totalReturn = compoundAmount - repeatingContribution;
    } else if (frequency == 'Weekly') {
      double weeklyRate = (roi / 100) / 52;
      compoundFrequency = (52 / 12);
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + weeklyRate) + repeatingContribution;
      }
      totalReturn = compoundAmount - repeatingContribution;
    } else if (frequency == 'Monthly') {
      double monthlyRate = (roi / 100) / 12;
      compoundFrequency = 1;
      for (int i = 0; i < (compoundFrequency * duration); i++) {
        compoundAmount =
            compoundAmount * (1 + monthlyRate) + repeatingContribution;
      }
    }

    double profit = totalReturn - compoundFrequency * duration;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 12),
        Text(
          'Profit After $duration Months',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text(
          '₹ ${profit.toStringAsFixed(2)}',
          style: TextStyle(fontSize: 16, color: Colors.black),
        ),
        SizedBox(height: 12),
        Divider(),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentPage(
                    totalAmount: initialamount,
                    duration: selectedDuration.toString(),
                    frequency: selectedFrequency.toString(),
                  ),
                ) // Navigate to PaymentPage
                );
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
          ),
          child: Text('Invest Now'),
        ),
      ],
    );
  }

  Widget _buildInitialAmountInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Initial Amount (in ₹)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          TextFormField(
            controller: initialAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: 'Enter initial amount',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              setState(() {
                initialamount = double.tryParse(value) ?? 0.0;
              });
            },
            // Add your logic to handle input changes or value retrieval here
          ),
          SizedBox(height: 12),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildFrequencyDropdown() {
    List<String> frequencyOptions = ['Daily', 'Weekly', 'Monthly'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Frequency',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 36,
                  elevation: 8,
                  hint: Text('Select Frequency',
                      style: TextStyle(color: Colors.black)),
                  value: selectedFrequency,
                  items: frequencyOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFrequency = newValue;
                    });
                  },
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Divider(),
        ],
      ),
    );
  }

  Widget _buildDurationDropdown() {
    List<String> durationOptions = ['6', '12', '18', '24', '36', '48'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 12),
          Text(
            'Duration (months)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  iconSize: 36,
                  elevation: 8,
                  hint: Text('Select Duration',
                      style: TextStyle(color: Colors.black)),
                  value: selectedDuration,
                  items: durationOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedDuration = newValue;
                    });
                  },
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 12),
          Divider(),
        ],
      ),
    );
  }
}
