import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 20),
          _buildSettingsSection("Informations du compte", [
            _buildSettingsItem("Changer le mot de passe", () {}),
            _buildSettingsItem("Éditer le profil", () {}),
          ]),
          const SizedBox(height: 20),
          _buildSettingsSection("Supports", [
            _buildSettingsItem("Notifications", () {}),
            _buildSettingsItem("Langues", () {}),
            _buildThemeSwitch(),
          ]),
          const SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Row(
      children: [
        CircleAvatar(radius: 30, backgroundColor: Colors.grey[300]),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text("email@example.com", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ],
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: items
                .expand((item) =>
            [item, if (item != items.last) const Divider(height: 1)])
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildThemeSwitch() {
    return ListTile(
      title: const Text("Thème"),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          signOut();

        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[100],
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child:
        const Text("Se déconnecter", style: TextStyle(color: Colors.black)),
      ),
    );
  }
  
  void signOut() {
    signOut();
  }
  
  
 
}
