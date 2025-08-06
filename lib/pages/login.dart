import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'home.dart'; // Import the new home screen

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
          // Background Image (Fixed)
          Positioned.fill(
            child: Image.asset("images/img.png", fit: BoxFit.cover),
          ),

          SafeArea(
            child: Align(
              alignment: Alignment(0, 0.7),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 50.0,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Email Input Field (Transparent)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          hintStyle: TextStyle(color: Colors.white70),
                          prefixIcon: Icon(
                            Icons.email_outlined,
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
                    const SizedBox(height: 20),

                    // Password Input Field (Transparent)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                      ),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
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
                    const SizedBox(height: 30),

                    // Login Button (Fixed Position)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _signInUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(
                            255,
                            54,
                            73,
                            88,
                          ).withAlpha((0.8 * 255).round()),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black54,
                        ),
                        child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Don't have an account? Sign Up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black54,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            // Direct navigation to Sign Up page
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignUp()),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              shadows: [
                                Shadow(
                                  offset: Offset(1, 1),
                                  blurRadius: 2,
                                  color: Colors.black54,
                                ),
                              ],
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
