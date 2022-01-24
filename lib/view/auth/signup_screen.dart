import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rentremedy_mobile/networking/api_exception.dart';
import 'package:rentremedy_mobile/networking/api_service.dart';

import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _statusMessage = '';
  late Color _messageColor = Colors.black;
  final TextEditingController txtFirstName = TextEditingController();
  final TextEditingController txtLastName = TextEditingController();
  final TextEditingController txtEmail = TextEditingController();
  final TextEditingController txtPassword = TextEditingController();
  ApiService apiService = ApiService();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(36),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 100),
                  titleLogo(),
                  SizedBox(height: 25),
                  statusMessage(),
                  firstNameInput(),
                  lastNameInput(),
                  emailInput(),
                  passwordInput(),
                  signupButton(),
                  Visibility(
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      visible: isLoading,
                      child: CircularProgressIndicator()),
                  showLoginButton(),
                ],
              ))),
    ));
  }

  Widget titleLogo() {
    return Text(
      "Signup",
      style: GoogleFonts.pacifico(
          fontWeight: FontWeight.bold, fontSize: 50, color: Colors.black),
    );
  }

  Widget statusMessage() {
    return Text(
      _statusMessage,
      style: TextStyle(
          fontSize: 16, color: _messageColor, fontWeight: FontWeight.bold),
    );
  }

  Widget firstNameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtFirstName,
          keyboardType: TextInputType.name,
          decoration:
              InputDecoration(hintText: 'First Name', icon: Icon(Icons.person)),
          validator: (text) => text!.isEmpty ? 'First Name is required' : null,
          onChanged: (value) {},
        ));
  }

  Widget lastNameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtLastName,
          keyboardType: TextInputType.name,
          decoration:
              InputDecoration(hintText: 'Last Name', icon: Icon(Icons.person)),
          validator: (text) => text!.isEmpty ? 'Last Name is required' : null,
        ));
  }

  Widget emailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtEmail,
          keyboardType: TextInputType.emailAddress,
          decoration:
              InputDecoration(hintText: 'Email', icon: Icon(Icons.email)),
          validator: (text) => text!.isEmpty ? 'Email is required' : null,
        ));
  }

  Widget passwordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 24),
        child: TextFormField(
          controller: txtPassword,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          decoration:
              InputDecoration(hintText: 'Password', icon: Icon(Icons.lock)),
          validator: (text) => text!.isEmpty ? 'Password is required' : null,
        ));
  }

  Widget signupButton() {
    return Padding(
        padding: EdgeInsets.only(top: 48),
        child: Container(
            height: 60,
            width: 200,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                ),
              ),
              child: Text(
                'Sign up',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    setState(() {
                      isLoading = true;
                    });
                    await apiService.signup(txtFirstName.text, txtLastName.text,
                        txtEmail.text, txtPassword.text);

                    setState(() {
                      _statusMessage = 'Signup Success';
                      _messageColor = Colors.green;
                      isLoading = false;
                    });
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => LoginScreen()));
                  } on BadRequestException catch (e) {
                    setState(() {
                      _statusMessage = e.toString();
                      _messageColor = Colors.red;
                      isLoading = false;
                    });
                  } on TimeoutException catch (e) {
                    setState(() {
                      _statusMessage = e.toString();
                      _messageColor = Colors.red;
                      isLoading = false;
                    });
                  }
                } else {
                  print('Missing required fields');
                }
              },
            )));
  }

  Widget showLoginButton() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(65, 20, 0, 0),
        child: Row(children: [
          Text(
            'Already have Account ? ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Text(
              'Login',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
        ]));
  }
}