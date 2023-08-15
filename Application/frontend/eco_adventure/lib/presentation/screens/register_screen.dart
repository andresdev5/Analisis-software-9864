import 'dart:convert';

import 'package:eco_adventure/presentation/models/auth_credential.dart';
import 'package:eco_adventure/presentation/models/user_model.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              leading: IconButton(
                onPressed: () {
                  context.replace('/');
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Color.fromARGB(255, 36, 170, 137),
                ),
              ),
              title: const Text(
                'Sign up',
                style: TextStyle(
                    color: Color.fromARGB(255, 36, 170, 137),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 80,
                  ),
                  const SizedBox(height: 20),
                  Center(
                      child: Text(
                    'Eco Adventure',
                    style: TextStyle(
                        color: Colors.green[900],
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 48.0, right: 48.0, top: 12, bottom: 5),
                      child: _RegisterForm(
                        onRegistered: () {},
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  final Function() onRegistered;

  const _RegisterForm({
    Key? key,
    required this.onRegistered,
  }) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();

  Future<void> register(BuildContext context, String username, String password, String email) async {
    try {
      var authProvider = context.read<AuthProvider>();
      await authProvider.register(User(username: username, email: email, password: password));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _username,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              // validar que tenga solo letras, numeros, puntos y guiones
              if (!RegExp(r'^[a-zA-Z0-9.-]+$').hasMatch(value)) {
                return 'only letters, numbers, dots and dashes are allowed';
              }

              if (value.length < 5 || value.length > 20) {
                return 'The username must be between 5 and 20 characters';
              }

              return null;
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              hintText: 'johndoe15',
              hintStyle: TextStyle(color: Color.fromARGB(175, 36, 170, 137)),
              label: Text('Username'),
              labelStyle: TextStyle(color: Color.fromARGB(255, 36, 170, 137)),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _email,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              // validar que sea un email
              if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value)) {
                return 'Invalid email address';
              }

              return null;
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              hintText: 'johndoe@example.com',
              hintStyle: TextStyle(color: Color.fromARGB(175, 36, 170, 137)),
              label: Text('Email'),
              labelStyle: TextStyle(color: Color.fromARGB(255, 36, 170, 137)),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              if (value.length < 4) {
                return 'The password must be at least 4 characters';
              }

              // validar que tenga una mayuscula, una minuscula y un numero
              if (!RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{4,}$')
                  .hasMatch(value)) {
                return 'The password must contain at least one uppercase letter, one lowercase letter and one number';
              }

              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              label: Text('Password'),
              labelStyle: TextStyle(color: Color.fromARGB(255, 36, 170, 137)),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _password2,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }

              if (value != _password.text) {
                return 'The passwords do not match';
              }

              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              label: Text('Confirm password'),
              labelStyle: TextStyle(color: Color.fromARGB(255, 36, 170, 137)),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: const Color.fromARGB(255, 36, 170, 137),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await register(
                      context, _username.text, _password.text, _email.text);
                  // clear fields
                  _username.clear();
                  _password.clear();
                  _password2.clear();
                  _email.clear();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
