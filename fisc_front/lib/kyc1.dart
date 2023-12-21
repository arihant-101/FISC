import 'package:flutter/material.dart';
import 'kyc2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: KYC1Page(),
    );
  }
}

class KYC1Page extends StatefulWidget {
  @override
  _KYC1PageState createState() => _KYC1PageState();
}

class _KYC1PageState extends State<KYC1Page> {
  DateTime _selectedDate = DateTime.now();
  TextEditingController _fullNameController = TextEditingController();
  String _gender = '';
  String _occupation = '';
  String _incomeSlab = '';

  List<String> monthsList = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  List<String> occupationOptions = [
    'Student',
    'Engineer',
    'Doctor',
    'Teacher',
    'Business Owner',
    'Freelancer',
    'Others'
  ];

  List<String> incomeSlabOptions = [
    'Below ₹ 1 Lakh',
    '₹ 1 Lakh - ₹ 5 Lakh',
    '₹ 5 Lakh - ₹ 9 Lakh',
    '₹ 9 Lakh - ₹ 12 Lakh',
    '₹ 12 Lakh - ₹ 16 Lakh',
    'Above ₹ 16 Lakh',
  ];

  void _showOptions(String field, List<String> options) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300.0,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'Select $field',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(height: 20, thickness: 2),
              Expanded(
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        options[index],
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        setState(() {
                          if (field == 'Occupation') {
                            _occupation = options[index];
                          } else if (field == 'Income Slab') {
                            _incomeSlab = options[index];
                          } else if (field == 'Gender') {
                            _gender = options[index];
                          }
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KYC Step 1'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(),
              SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              _buildDropdownField(
                  'Gender', ['Male', 'Female', 'Others'], _gender),
              SizedBox(height: 20),
              _buildDropdownField('Occupation', occupationOptions, _occupation),
              SizedBox(height: 20),
              _buildDropdownField(
                  'Income Slab', incomeSlabOptions, _incomeSlab),
              SizedBox(height: 20),
              _buildDateSelector(),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  String fullName = _fullNameController.text;
                  String dob =
                      '${_selectedDate.day} ${monthsList[_selectedDate.month - 1]} ${_selectedDate.year}';

                  print('Full Name: $fullName');
                  print('Gender: $_gender');
                  print('Occupation: $_occupation');
                  print('Income Slab: $_incomeSlab');
                  print('Date of Birth: $dob');

                  // Navigate to KYC2Page on button press
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => KYC2Page()),
                  );
                },
                child: Text(
                  'Proceed',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(String field, List<String> options, String value) {
    return GestureDetector(
      onTap: () => _showOptions(field, options),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: field,
          border: OutlineInputBorder(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value.isEmpty ? 'Select $field' : value,
              style: TextStyle(fontSize: 18),
            ),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      title: Text(
        'Date of Birth:',
        style: TextStyle(fontSize: 18),
      ),
      subtitle: Text(
        '${_selectedDate.day} ${monthsList[_selectedDate.month - 1]} ${_selectedDate.year}',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      trailing: Icon(Icons.calendar_today),
      onTap: () {
        _selectDate(context);
      },
    );
  }
}
