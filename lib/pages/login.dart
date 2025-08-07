// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> _signInUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill all fields', Colors.red);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      _showSnackBar('Login successful!', Colors.green);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This user has been disabled.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      _showSnackBar(errorMessage, Colors.red);
    } catch (e) {
      _showSnackBar('An unexpected error occurred: $e', Colors.red);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("images/img.png", fit: BoxFit.cover),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color.fromARGB(
                            0,
                            0,
                            0,
                            0,
                          ).withOpacity(0.1),
                        ),
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Email or Phone',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.white, width: 2),
                          color: const Color.fromARGB(
                            0,
                            0,
                            0,
                            0,
                          ).withOpacity(0.1),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.white,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signInUser,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                37,
                                50,
                                56,
                              ),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 15),

                        const Text(
                          'or',
                          style: TextStyle(color: Colors.black54, fontSize: 16),
                        ),
                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(
                                255,
                                186,
                                200,
                                205,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: const Text(
                              'Create an account',
                              style: TextStyle(
                                color: Color.fromARGB(255, 37, 50, 56),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
