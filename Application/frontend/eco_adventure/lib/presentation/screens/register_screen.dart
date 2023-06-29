import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

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
          body: Container(
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
                const Padding(
                    padding: EdgeInsets.only(
                        left: 48.0, right: 48.0, top: 12, bottom: 5),
                    child: _RegisterForm())
              ],
            ),
          ),
        ));
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({Key? key}) : super(key: key);

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _password2 = TextEditingController();

  Future<void> register(BuildContext context, String username, String password,
      String email) async {
    try {
      final response =
          await http.post(Uri.parse('http://10.0.2.2:3000/auth/register'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(<String, String>{
                'username': username,
                'email': email,
                'password': password,
              }));

      if (response.statusCode != 200) {
        final json = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json['message'] as String)),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo registrar')),
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
