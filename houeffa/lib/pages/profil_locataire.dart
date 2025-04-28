import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:houeffa/services/auth.dart';
import 'package:intl/intl.dart'; // Importation de la bibliothèque intl pour le formatage des dates

class ProfilLocatairePage extends StatefulWidget {
  const ProfilLocatairePage({Key? key}) : super(key: key);

  @override
  State<ProfilLocatairePage> createState() => _ProfilLocatairePageState();
}

class _ProfilLocatairePageState extends State<ProfilLocatairePage> {
  final AuthService _authService = AuthService();//instenciation de la class AuthService
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  
  //  Utilisation de DateTime? pour stocker la date de naissance
  DateTime? _birthDate;
  String _birthDateDisplay = 'Select date';
  String _gender = 'Select gender';
  bool _isLoading = true;
  String? _photoUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        Map<String, dynamic>? userData = await _authService.getUserData(currentUser.uid);
        
        if (userData != null) {
          setState(() {
            _firstNameController.text = userData['displayName']?.split(' ').first ?? '';
            _lastNameController.text = userData['displayName']?.split(' ').length > 1 
                ? userData['displayName']?.split(' ').sublist(1).join(' ') ?? ''
                : '';
            _usernameController.text = userData['username'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phone'] ?? '';
            
            // Modification: Traitement de la date depuis Firestore
            if (userData['birth'] != null && userData['birth'] != 'Select date') {
              try {
                // Vérifier si la date est déjà un Timestamp Firestore
                if (userData['birth'] is Timestamp) {
                  _birthDate = (userData['birth'] as Timestamp).toDate();
                  _birthDateDisplay = DateFormat('dd/MM/yyyy').format(_birthDate!);
                } else {
                  // Essayer de parser la chaîne de date
                  _birthDateDisplay = userData['birth'];
                  try {
                    _birthDate = DateFormat('dd/MM/yyyy').parse(userData['birth']);
                  } catch (e) {
                    // Fallback si le format n'est pas reconnu
                    _birthDate = null;
                  }
                }
              } catch (e) {
                debugPrint('Error parsing birth date: $e');
                _birthDate = null;
                _birthDateDisplay = 'Select date';
              }
            } else {
              _birthDate = null;
              _birthDateDisplay = 'Select date';
            }
            
            _gender = userData['gender'] ?? 'Select gender';
            _photoUrl = userData['photoURL'];
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Modification: Nouvelle méthode pour afficher le sélecteur de date
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      // Personnalisation optionnelle du calendrier
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              surface: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
        _birthDateDisplay = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        // Combine first and last name for displayName
        String displayName = '${_firstNameController.text} ${_lastNameController.text}';
        
        // Update user profile
        bool success = await _authService.updateUserProfile(
          uid: currentUser.uid,
          displayName: displayName,
          phone: _phoneController.text,
          // Pass other fields as needed
        );
        
        // Update additional fields in Firestore
        if (success) {
          // Modification: Sauvegarder la date de naissance
          await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).update({
            'username': _usernameController.text,
            'birth': _birthDate != null ? Timestamp.fromDate(_birthDate!) : null,
            'gender': _gender,
            'updatedAt': FieldValue.serverTimestamp(),
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully')),
          );
          
          Navigator.pop(context);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      // Back button
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Profile picture
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _photoUrl != null 
                                ? NetworkImage(_photoUrl!) 
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      
                      // Title
                      const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      
                      // First name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('First Name'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Last name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Last Name'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Username
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Username'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Email
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Email'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _emailController,
                            readOnly: true, // Email shouldn't be editable
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              filled: true,
                              fillColor: Colors.grey[200],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Phone number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Phone Number'),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                              prefixIcon: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                                    const SizedBox(width: 4),
                                  ],
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.phone,
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Modification: Date de naissance avec DatePicker
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Birth Date'),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () => _selectDate(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _birthDateDisplay,
                                    style: TextStyle(
                                      color: _birthDate == null ? Colors.grey : Colors.black,
                                    ),
                                  ),
                                  Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      
                      // Gender dropdown
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Gender'),
                          const SizedBox(height: 5),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: _gender,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              ),
                              items: ['Select gender', 'Male', 'Female', 'Other']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _gender = newValue!;
                                });
                              },
                              icon: const Icon(Icons.arrow_drop_down),
                              isExpanded: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      
                      // Save button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveProfile,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(' Sauvegarder les modofications'),
                              SizedBox(width: 8),
                              Icon(Icons.lock, size: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

// Le reste du code reste inchangé

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = true;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        Map<String, dynamic>? userData = await _authService.getUserData(currentUser.uid);
        
        setState(() {
          _userData = userData;
        });
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.signOut();
      // Navigate to login screen or handle logout in your app's navigation
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing out: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // Header with back button and title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Text(
                          'My Profile',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.settings),
                          onPressed: () {
                            // Navigate to settings or show settings modal
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    
                    // Profile info with edit button
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: _userData?['photoURL'] != null 
                                ? NetworkImage(_userData!['photoURL']) 
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _userData?['displayName'] ?? 'User',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            _userData?['email'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilLocatairePage(),
                                ),
                              ).then((_) => _loadUserData());
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text('Edit Profile'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    
                    // Menu Items
                    _buildMenuItem(
                      icon: Icons.favorite_border,
                      title: 'Favourites',
                      onTap: () {
                        // Navigate to favourites
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.download_outlined,
                      title: 'Downloads',
                      onTap: () {
                        // Navigate to downloads
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.language,
                      title: 'Languages',
                      onTap: () {
                        // Open language settings
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      onTap: () {
                        // Open location settings
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.credit_card_outlined,
                      title: 'Subscription',
                      onTap: () {
                        // Open subscription details
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.desktop_windows_outlined,
                      title: 'Display',
                      onTap: () {
                        // Open display settings
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.cleaning_services_outlined,
                      title: 'Clear Cache',
                      onTap: () {
                        // Show clear cache confirmation
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.history,
                      title: 'Clear History',
                      onTap: () {
                        // Show clear history confirmation
                      },
                    ),
                    _buildDivider(),
                    
                    _buildMenuItem(
                      icon: Icons.logout,
                      title: 'Log Out',
                      onTap: _logout,
                    ),
                    
                    const SizedBox(height: 20),
                    // App version
                    Center(
                      child: Text(
                        'App Version 1.0.3',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1);
  }
}

// Main implementation example
class ProfileModule extends StatelessWidget {
  const ProfileModule({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const ProfilePage(),
    );
  }
}

// Pour les tests uniquement - dans votre application, intégrez ceci à votre main.dart existant
void main() async {
  // Initialiser Firebase
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  
  runApp(const ProfileModule());
}
