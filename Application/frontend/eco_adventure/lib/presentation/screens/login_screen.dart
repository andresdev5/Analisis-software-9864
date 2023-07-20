import 'dart:convert';

import 'package:eco_adventure/presentation/models/auth_credential.dart';
import 'package:eco_adventure/presentation/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                'Sign in',
                style: TextStyle(
                    color: Color.fromARGB(255, 36, 170, 137),
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
          backgroundColor: Colors.transparent,
          body: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50),
            child: Column(
              children: [
                const Image(
                  image: AssetImage('assets/logo.png'),
                  width: 140,
                ),
                const SizedBox(height: 20),
                Center(
                    child: Text(
                  'Eco Adventure',
                  style: TextStyle(
                      color: Colors.green[900],
                      fontSize: 28,
                      fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 40),
                const Padding(
                  padding: EdgeInsets.all(48.0),
                  child: Column(
                    children: [
                      _LoginForm(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm({Key? key}) : super(key: key);

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  Future<void> login(BuildContext context, String username, String password) async {
    try {
      var authProvider = context.read<AuthProvider>();
      var loggedIn = await authProvider
          .login(AuthCredential(username: username, password: password));

      if (loggedIn) {
        context.replace('/home');
      } else {
        throw Exception('Invalid credentials');
      }
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
        child: Column(children: [
          TextFormField(
            controller: _username,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter username';
              }
              return null;
            },
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              hintText: 'Username',
              hintStyle: TextStyle(
                color: Color.fromARGB(175, 36, 170, 137),
              ),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _password,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the password';
              }
              return null;
            },
            obscureText: true,
            decoration: const InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 238, 250, 246),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Color.fromARGB(175, 36, 170, 137),
              ),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 40),
          // button full width
          SizedBox(
            width: double.infinity,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                backgroundColor: const Color.fromARGB(255, 36, 170, 137),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  var username = _username.value.text;
                  var password = _password.value.text;

                  await login(context, username, password);
                }
              },
              child: const Text(
                'Sign in',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]));
  }
}
