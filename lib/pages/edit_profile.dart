import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zesh_app/widget/support_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _profilePictureUrl;
  File? _selectedImage;
  bool _isLoading = false;

  final User? _currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (_currentUser == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        _nameController.text = userData['name'] ?? '';
        _emailController.text = userData['email'] ?? '';
        _phoneController.text = userData['phone'] ?? '';
        _addressController.text = userData['address'] ?? '';
        _profilePictureUrl = userData['profilePictureUrl'];
      } else {
        // If user document doesn't exist, populate with Firebase Auth data
        _nameController.text = _currentUser!.displayName ?? '';
        _emailController.text = _currentUser!.email ?? '';
      }
    } catch (e) {
      print('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return null;

    try {
      String fileName =
          'profile_pictures/${_currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      UploadTask uploadTask = _storage.ref().child(fileName).putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload image: $e')),
      );
      return null;
    }
  }

  Future<void> _saveProfile() async {
    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No user logged in.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String? newProfilePictureUrl = _profilePictureUrl;
      if (_selectedImage != null) {
        newProfilePictureUrl = await _uploadImage();
      }

      Map<String, dynamic> userData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'address': _addressController.text,
        'profilePictureUrl': newProfilePictureUrl,
      };

      await _firestore.collection('users').doc(_currentUser!.uid).set(userData, SetOptions(merge: true));

      // Update Firebase Auth profile if name or email changed
      if (_currentUser!.displayName != _nameController.text ||
          _currentUser!.email != _emailController.text) {
        await _currentUser!.updateDisplayName(_nameController.text);
        // Note: Updating email directly via updateEmail requires re-authentication.
        // For simplicity, we're only updating it in Firestore here.
        // If full email update is needed, a re-auth flow should be implemented.
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context); // Go back to profile screen
    } catch (e) {
      print('Error saving profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (_profilePictureUrl != null
                              ? NetworkImage(_profilePictureUrl!)
                              : const AssetImage('images/logo.png')) as ImageProvider,
                      child: _selectedImage == null && _profilePictureUrl == null
                          ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[600])
                          : null,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField(
                    controller: _nameController,
                    label: 'Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    readOnly: true, // Email usually not directly editable via profile
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _phoneController,
                    label: 'Phone',
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: _addressController,
                    label: 'Delivery Address',
                    icon: Icons.location_on,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2A3A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Profile',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF1A2A3A), width: 2),
        ),
      ),
    );
  }
}
