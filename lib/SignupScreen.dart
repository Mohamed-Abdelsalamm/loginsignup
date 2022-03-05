// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'TodoApp.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey();

  // String? userUid;
  // late final userEmail;

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   emailController.dispose();
  //   passwordController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.teal,
            )),
      ),
      body: Form(
        key: formKey,
        child: SafeArea(
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: nameController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 3) {
                          return 'Invalid Name';
                        }
                        return null;
                      },
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      textAlign: TextAlign.start,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Invalid password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.vpn_key),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneController,
                      validator: (value) {
                        if (value!.isEmpty || value.length < 6) {
                          return 'Invalid Phone number';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_android),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                                  .createUserWithEmailAndPassword(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim());
// FirebaseAuth.instance.signInWithEmailAndPassword(email: , password: password)
                             await FirebaseFirestore.instance.collection("users").doc(emailController.text.trim()).set({
                                'name':nameController.text.trim(),
                                'email':emailController.text.trim(),
                                'password':passwordController.text.trim(),
                                'phone':phoneController.text.trim(),
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TodoApp(),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Signed up successfully!")));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                              print(e.toString());
                            }
                          }
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  signup(String email, String password) {}
}
