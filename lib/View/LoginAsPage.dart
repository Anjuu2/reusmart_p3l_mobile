import 'package:flutter/material.dart';

class LoginAsPage extends StatelessWidget {
  final String userType;

  LoginAsPage({required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Sebagai $userType'),
      ),
      body: Center(
        child: Text(
          'Halaman login sebagai $userType',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
