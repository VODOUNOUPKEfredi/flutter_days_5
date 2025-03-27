// import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:houeffa/pages/homePage.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// import 'package:houeffa/pages/login_page.dart';
// import 'package:provider/provider.dart';
// import 'package:houeffa/provider/auth_provider.dart';
// import 'firebase_options.dart';


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//       providers: [
//         // Provider pour AuthProvider
//         ChangeNotifierProvider<AuthProvider>(
//           create: (_) => AuthProvider(),
//         ),
//         // Provider pour l'authentification Firebase
//         StreamProvider<User?>.value(
//           value: FirebaseAuth.instance.authStateChanges(),
//           initialData: null,
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Firebase Auth Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           visualDensity: VisualDensity.adaptivePlatformDensity,
//         ),
//         home: AuthWrapper(),
//       ),
//     );
//   }
// }

// // Widget qui décide quelle vue afficher en fonction de l'état d'authentification
// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Récupération de l'utilisateur depuis le Provider
//     final user = Provider.of<User?>(context);
    
//     // Si l'utilisateur est connecté, afficher la page d'accueil
//     // Sinon, afficher la page de connexion
//     return user != null ? LocataireHomePage() : LoginPage();
//   }
// }
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:houeffa/pages/login_page.dart';
import 'package:houeffa/pages/navBar.dart';
import 'package:provider/provider.dart';
import 'package:houeffa/provider/auth_provider.dart';
import 'firebase_options.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp(
  )
);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthProvider>(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

// Widget qui décide quelle vue afficher en fonction de l'état d'authentification
class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Récupération du provider d'authentification
    final authProvider = Provider.of<AuthProvider>(context);

    // Vérifier si un utilisateur est authentifié
    if (authProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return authProvider.isAuthenticated ? Navbar() : LoginPage();
  }
}
