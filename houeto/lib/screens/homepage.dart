import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('HOUETO'),
          actions: [
            IconButton(
              icon: Icon(Icons.person_outline),
              onPressed: () {},
            ),
          ],
          backgroundColor: const Color.fromARGB(255, 129, 194, 248),

          
        ),
              
      )
    ); 
 }
}