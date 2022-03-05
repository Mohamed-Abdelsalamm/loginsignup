import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'SignupScreen.dart';
import 'TodoApp.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  bool passwordVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid email!';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Invalid password';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: passwordVisibility,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.vpn_key),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            passwordVisibility
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorDark,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              passwordVisibility = !passwordVisibility;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      color: Colors.teal,
                      width: double.infinity,
                      height: 50.0,
                      child: MaterialButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoApp(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Welcome to ToDo App 😊 ")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                              print(e.toString());
                            }
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Don't Have Account ?",
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                            );
                          });
                        },
                        child: Text(
                          'Sign UP',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
