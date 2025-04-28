// import 'package:flutter/material.dart';
// import 'package:houeffa/pages/navBar.dart';
// import 'package:houeffa/pages/resert_password_page.dart';
// import 'package:houeffa/pages/signup-page.dart';
// import 'package:houeffa/provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// /// Page de connexion
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // Contrôleurs pour les champs de formulaire
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   // Clé du formulaire pour la validation
//   final _formKey = GlobalKey<FormState>();

//   // Visibilité du mot de passe
//   bool _obscurePassword = true;

//   @override
//   void dispose() {
//     // Libérer les ressources
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Accéder au provider d'authentification
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text('Connexion'), centerTitle: true),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 // Logo ou titre
//                 const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
//                 const SizedBox(height: 32),

//                 // Champ d'email
//                 TextFormField(
//                   controller: _emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     prefixIcon: Icon(Icons.email),
//                     border: OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     // Validation de l'email
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre email';
//                     }
//                     if (!RegExp(
//                       r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                     ).hasMatch(value)) {
//                       return 'Veuillez entrer un email valide';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Champ de mot de passe
//                 TextFormField(
//                   controller: _passwordController,
//                   obscureText: _obscurePassword,
//                   decoration: InputDecoration(
//                     labelText: 'Mot de passe',
//                     prefixIcon: const Icon(Icons.lock),
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         _obscurePassword
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                       onPressed: () {
//                         // Changer la visibilité du mot de passe
//                         setState(() {
//                           _obscurePassword = !_obscurePassword;
//                         });
//                       },
//                     ),
//                     border: const OutlineInputBorder(),
//                   ),
//                   validator: (value) {
//                     // Validation du mot de passe
//                     if (value == null || value.isEmpty) {
//                       return 'Veuillez entrer votre mot de passe';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 8),

//                 // Lien "Mot de passe oublié"
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       // Navigation vers la page de réinitialisation de mot de passe
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const ResetPasswordPage(),
//                         ),
//                       );
//                     },
//                     child: const Text('Mot de passe oublié?'),
//                   ),
//                 ),
//                 const SizedBox(height: 24),

//                 // Bouton de connexion
//                 ElevatedButton(
//                   onPressed:
//                       authProvider.isLoading
//                           ? null // Désactiver pendant le chargement
//                           : () async {
//                             // Valider le formulaire
//                             if (_formKey.currentState!.validate()) {
//                               // Tenter de se connecter
//                               final success = await authProvider.signIn(
//                                 email: _emailController.text.trim(),
//                                 password: _passwordController.text,
//                               );

//                               // Ne pas utiliser mounted dans un bloc asynchrone sans vérification
//                               if (!mounted) return;

//                               // Afficher un message d'erreur si la connexion échoue
//                               // if (!success && authProvider.errorMessage != null) {
//                               //   ScaffoldMessenger.of(context).showSnackBar(
//                               //     SnackBar(
//                               //       content: Text(authProvider.errorMessage!),
//                               //       backgroundColor: Colors.red,
//                               //     ),
//                               //   );
//                               // }
//                               if (success) {
//                                 Navigator.pushReplacement(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => const Navbar(),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child:
//                       authProvider.isLoading
//                           ? const CircularProgressIndicator()
//                           : const Text(
//                             'Se connecter',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                 ),
//                 const SizedBox(height: 16),

//                 // Lien d'inscription
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text('Pas encore de compte?'),
//                     TextButton(
//                       onPressed: () {
//                         // Navigation vers la page d'inscription
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const SignupPage(),
//                           ),
//                         );
//                       },
//                       child: const Text('S\'inscrire'),
//                     ),
//                   ],
//                 ),

//                 // Affichage des erreurs
//                 if (authProvider.errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16),
//                     child: Text(
//                       authProvider.errorMessage!,
//                       style: const TextStyle(color: Colors.red),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:houeffa/pages/navBar.dart';
import 'package:houeffa/pages/resert_password_page.dart';
import 'package:houeffa/pages/signup-page.dart';
import 'package:houeffa/provider/auth_provider.dart';
import 'package:provider/provider.dart';

/// Page de connexion
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Contrôleurs pour les champs de formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Clé du formulaire pour la validation
  final _formKey = GlobalKey<FormState>();

  // Visibilité du mot de passe
  bool _obscurePassword = true;

  @override
  void dispose() {
    // Libérer les ressources
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accéder au provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Connexion'), centerTitle: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo ou titre
                const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
                const SizedBox(height: 32),

                // Champ d'email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Veuillez entrer un email valide';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Champ de mot de passe
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),

                // Lien "Mot de passe oublié"
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ResetPasswordPage(),
                        ),
                      );
                    },
                    child: const Text('Mot de passe oublié?'),
                  ),
                ),
                const SizedBox(height: 24),

                // Bouton de connexion
                ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await authProvider.signIn(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );

                            if (!mounted) return;

                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Navbar(),
                                ),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Se connecter',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 16),

                // Bouton Google Sign-In
                ElevatedButton.icon(
                  onPressed: () async {
                    final success = await authProvider.signInWithGoogle();
                    if (!mounted) return;
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const Navbar()),
                      );
                    }
                  },
                  icon: Image.asset(
                    'asset/google_logo.png',
                    height: 24,
                  ), 
                  label: const Text(
                    'Se connecter avec Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Lien d'inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Pas encore de compte?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupPage(),
                          ),
                        );
                      },
                      child: const Text('S\'inscrire'),
                    ),
                  ],
                ),

                // Affichage des erreurs
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text(
                      authProvider.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
