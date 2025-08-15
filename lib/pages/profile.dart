import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:zesh_app/pages/edit_profile.dart';
import 'package:zesh_app/pages/login.dart';
import 'package:zesh_app/providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onBackground),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Profile', style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(isDarkMode),
          const SizedBox(height: 20),
          _buildProfileItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              _navigateToLoginAndRemoveUntil();
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'General Settings',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
          _buildDarkModeToggle(themeProvider, isDarkMode),
          _buildProfileItem(
            icon: Icons.language,
            text: 'Language',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.info_outline,
            text: 'About',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.article_outlined,
            text: 'Terms & Conditions',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.lock_outline,
            text: 'Privacy Policy',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.star_outline,
            text: 'Rate This App',
            onTap: () {},
          ),
          _buildProfileItem(
            icon: Icons.share_outlined,
            text: 'Share This App',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('images/logo.png'),
        ),
        const SizedBox(height: 10),
        Text(
          _currentUser?.displayName ?? 'N/A',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(height: 5),
        Text(_currentUser?.email ?? 'N/A', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditProfileScreen()),
            ).then((_) {
              // Refresh user data when returning from EditProfileScreen
              setState(() {
                _currentUser = FirebaseAuth.instance.currentUser;
              });
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A2A3A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            'Edit Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
      title: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDarkModeToggle(ThemeProvider themeProvider, bool isDarkMode) {
    return ListTile(
      leading: Icon(Icons.brightness_6_outlined, color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Mode', style: TextStyle(color: Theme.of(context).colorScheme.onBackground)),
          const Text(
            'Dark & Light',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          themeProvider.toggleTheme(value);
        },
        activeColor: Colors.blue,
      ),
    );
  }

  void _navigateToLoginAndRemoveUntil() {
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (Route<dynamic> route) => false,
    );
  }
}
