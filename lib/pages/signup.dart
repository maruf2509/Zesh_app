import 'package:flutter/material.dart';
import 'login.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool agree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Blue Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24.0, 70.0, 24.0, 40.0),
              decoration: const BoxDecoration(
                color: Color.fromRGBO(43, 74, 77, 1),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // "Let's" - 1st line
                  const Text(
                    "Let's",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      height: 1.0,
                    ),
                  ),
                  // "Create" - 2nd line 
                  const Text(
                    "Create",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                  // "Your" - 3rd line 
                  const Text(
                    "Your",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                  // "Account" - 4th line 
                  const Text(
                    "Account",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      height: 0.9,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Full Name
                  buildInputField("Full Name", Icons.person_outline),
                  const SizedBox(height: 20),
                  // Email
                  buildInputField("Email Address", Icons.email_outlined),
                  const SizedBox(height: 20),
                  // Password
                  buildInputField("Password", Icons.lock_outline, obscure: true),
                  const SizedBox(height: 20),
                  // Retype Password
                  buildInputField("Retype Password", Icons.lock_outline, obscure: true),

                  const SizedBox(height: 25),

                  // Checkbox Row
                  Row(
                    children: [
                      Checkbox(
                        value: agree,
                        onChanged: (value) {
                          setState(() {
                            agree = value ?? false;
                          });
                        },
                        shape: const CircleBorder(),
                        activeColor: Colors.blue,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                            children: const [
                              TextSpan(text: 'I agree to the '),
                              TextSpan(
                                text: 'Terms & Privacy',
                                style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2F4F4F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Already have account - Now with navigation
                  GestureDetector(
                    onTap: () {
                      // Navigate to Login page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Login()),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        children: const [
                          TextSpan(text: 'Have an account? '),
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for input fields
  Widget buildInputField(String hint, IconData icon, {bool obscure = false}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextField(
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(icon, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}