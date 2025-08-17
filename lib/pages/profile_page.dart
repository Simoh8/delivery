import 'package:flutter/material.dart';
import 'package:delivery/pages/login.dart';
import 'package:delivery/services/session_manager.dart';
import 'package:delivery/services/ApiService.dart';
import 'package:delivery/models/user_info.dart';
import 'package:delivery/constants/app_constants.dart';
import 'package:provider/provider.dart';

import 'package:flutter/cupertino.dart';

import '../theme/theme_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserInfo? userInfo;
  bool loading = true;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFromCache();
    _fetchAndUpdateUserInfo();
  }

  Future<void> _loadFromCache() async {
    final cachedUser = await SessionManager.getUser();
    if (cachedUser != null && mounted) {
      setState(() {
        userInfo = cachedUser;
        loading = false;
      });
    }
  }

  Future<void> _fetchAndUpdateUserInfo() async {
    try {
      final response = await ApiService.get(AppConstants.fecthUserInfoEndpoint);
      final data = response['message'];
      if (data != null && data['success_key'] == 1) {
        final info = UserInfo.fromJson(data['data']);
        await SessionManager.saveUserInfo(info);

        if (mounted) {
          setState(() {
            userInfo = info;
            loading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching user info: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load user info")),
        );
      }
    }
  }

  Future<void> _updateUserInfo() async {
    final body = {
      'first_name': firstNameController.text,
      'middle_name': middleNameController.text,
      'last_name': lastNameController.text,
      'mobile_no': mobileController.text,
    };

    try {
      final response = await ApiService.post(AppConstants.updateUserInfoEndpoint,body,
      );

      final result = response['message'];
      debugPrint('Update response: $result');

      if (result['success'] == true) {
        if (!mounted) return;
        Navigator.of(context).pop(); // close dialog
        await _fetchAndUpdateUserInfo();

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline,
                        color: Colors.green, size: 64),
                    const SizedBox(height: 16),
                    const Text(
                      'Profile updated successfully',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update failed: ${result['error'] ?? 'Unknown error'}')),
          );
        }
      }
    } catch (e) {
      debugPrint('❌ Error updating user: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error updating profile")),
        );
      }
    }
  }

  // void _logout(BuildContext context) async {
  //   await SessionManager.logout();
  //   if (!mounted) return;
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (_) => const Login()),
  //         (route) => false,
  //   );
  // }

  void _showEditDialog() {
    final nameParts = userInfo?.fullName.split(' ') ?? [];
    firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
    middleNameController.text = nameParts.length == 3 ? nameParts[1] : '';
    lastNameController.text = nameParts.length > 1
        ? nameParts.sublist(nameParts.length - 1).join(' ')
        : '';
    mobileController.text = userInfo?.mobile ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: middleNameController,
                decoration: const InputDecoration(labelText: 'Middle Name'),
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: mobileController,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _updateUserInfo,
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CupertinoSlidingSegmentedControl<int>(
              groupValue: themeProvider.themeMode == ThemeMode.dark ? 1 : 0,
              children: const {
                0: Text("Light"),
                1: Text("Dark"),
              },
              onValueChanged: (index) {
                if (index == 0) {
                  themeProvider.toggleTheme(false);
                } else {
                  themeProvider.toggleTheme(true);
                }
              },
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: userInfo?.profileImage.isNotEmpty == true
                  ? NetworkImage('${AppConstants.baseUrl}${userInfo!.profileImage}')
                  : const NetworkImage('https://example.com/profile.jpg'),
            ),
            const SizedBox(height: 16),
            Text(
              userInfo?.fullName ?? 'N/A',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              userInfo?.email ?? 'N/A',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text("Edit Profile"),
              onPressed: _showEditDialog,
            ),
            const SizedBox(height: 24),
            _buildProfileCard(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(ThemeData theme) {
    return Card(
      color: theme.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildItem(Icons.person, 'Username', userInfo?.username, theme),
            const Divider(),
            _buildItem(Icons.phone, 'Mobile', userInfo?.mobile, theme),
            const Divider(),
            _buildItem(Icons.language, 'Language', userInfo?.language, theme),
            const Divider(),
            _buildItem(Icons.lock, 'Enabled', userInfo?.enabled.toString(), theme),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(IconData icon, String label, String? value, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: theme.iconTheme.color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$label: ${value ?? "N/A"}',
              style: theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
