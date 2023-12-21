import 'package:flutter/material.dart';

class PurchaseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase Gold'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Add functionality for the button here
            // For instance, you can navigate to another page or perform an action
          },
          child: Text('Purchase Gold'),
        ),
      ),
    );
  }
}
