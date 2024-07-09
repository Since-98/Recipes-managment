import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recipe_management/services/authentication_services.dart';

class InloggenPage extends StatefulWidget {
  void Function(bool status) setAutenticatiestatus;
  InloggenPage({super.key, required this.setAutenticatiestatus});

  @override
  State<InloggenPage> createState() => _InloggenPageState();
}

class _InloggenPageState extends State<InloggenPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Inloggen')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding:const EdgeInsets.all(8.0),
          children: [
            _logo(),
            SizedBox(height: 20),
            _email(),
            SizedBox(height: 20),
            _password(),
            SizedBox(height: 20),
            _submit(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return SizedBox(
      height: 250,
      child: Image.asset('lib/assets/images/download (1).jpg'),
    );
  }

  Widget _email() {
    return TextFormField(
      controller: _emailTextController,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Email address',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your email address';
        }
        return null;
      },
    );
  }

  Widget _password() {
    return TextFormField(
      controller: _passwordController,
      textInputAction: TextInputAction.done,
      obscureText: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Password',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your password';
        }
        return null;
      },
    );
  }

  Widget _submit() {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            final result = await AuthenticationServices.login(
              _emailTextController.text,
              _passwordController.text,
            );
            widget.setAutenticatiestatus(result);
          } catch (e) {
            print('Error logging in: $e');
            widget.setAutenticatiestatus(false);
          }
        }
      },
      child: Text('Inloggen'),
    );
  }
}
