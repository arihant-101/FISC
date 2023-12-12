import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SettingsScreen(),
  ));
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSection(
                context,
                'Profile',
                Icons.person,
                ProfileSettingsPage(),
                Colors.blue,
              ),
              _buildSectionDivider(),
              _buildSection(
                context,
                'Notifications',
                Icons.notifications,
                NotificationSettingsPage(),
                Colors.green,
              ),
              _buildSectionDivider(),
              _buildSection(
                context,
                'FAQs',
                Icons.help,
                FAQsPage(),
                Colors.orange,
              ),
              _buildSectionDivider(),
              _buildSection(
                context,
                'Contact Us',
                Icons.contact_mail,
                ContactUsPage(),
                Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon,
      Widget page, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 16),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return SizedBox(height: 16.0);
  }
}



class ProfileSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildProfileInfo('Name', 'John Doe', true),
            _buildProfileInfo('Phone No', '123-456-7890', true),
            _buildProfileInfo('PAN Card', 'ABCDE1234F', true),
            _buildProfileInfo('Aadhar Card', '1234 5678 9012', false),
            _buildProfileInfo('KYC', 'Verified', true),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, bool isVerified) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 18),
              ),
              if (isVerified)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Icon(Icons.verified, color: Colors.blue, size: 18),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class NotificationSettingsPage extends StatefulWidget {
  @override
  _NotificationSettingsPageState createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool transactionAlerts = true;
  bool newsUpdates = false;
  bool promotions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationSwitch('Email Notifications', emailNotifications),
            _buildNotificationSwitch('Push Notifications', pushNotifications),
            _buildNotificationSwitch('Transaction Alerts', transactionAlerts),
            _buildNotificationSwitch('News Updates', newsUpdates),
            _buildNotificationSwitch('Promotions', promotions),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              setState(() {
                if (label == 'Email Notifications') {
                  emailNotifications = newValue;
                } else if (label == 'Push Notifications') {
                  pushNotifications = newValue;
                } else if (label == 'Transaction Alerts') {
                  transactionAlerts = newValue;
                } else if (label == 'News Updates') {
                  newsUpdates = newValue;
                } else if (label == 'Promotions') {
                  promotions = newValue;
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

class FAQsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQs',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQEntry('Q1. What is this app about?',
                'This app helps you manage your financial investments.'),
            _buildFAQEntry('Q2. How to contact customer support?',
                'You can find contact details in the Contact Us section.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQEntry(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContactInfo(
                'Customer Support', 'support@example.com', '123-456-7890'),
            _buildContactInfo('Sales', 'sales@example.com', '987-654-3210'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(String department, String email, String phone) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$department:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.email, size: 18, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                email,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.phone, size: 18, color: Colors.teal),
              SizedBox(width: 8),
              Text(
                phone,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}