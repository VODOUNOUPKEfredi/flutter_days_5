import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoris'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mes logements favoris',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Liste des favoris
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Exemple avec 3 favoris
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image de l'appartement (simulée avec un container)
                        Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(
                              Icons.home,
                              size: 50,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Appartement ${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 8),
                              
                              const Text(
                                'Quartier, Ville',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              const Text(
                                '450 000 FCFA / mois',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              
                              const SizedBox(height: 8),
                              
                              const Row(
                                children: [
                                  Icon(Icons.bed, size: 16),
                                  SizedBox(width: 4),
                                  Text('2'),
                                  SizedBox(width: 16),
                                  Icon(Icons.bathtub, size: 16),
                                  SizedBox(width: 4),
                                  Text('1'),
                                  SizedBox(width: 16),
                                  Icon(Icons.square_foot, size: 16),
                                  SizedBox(width: 4),
                                  Text('75 m²'),
                                ],
                              ),
                              
                              const SizedBox(height: 12),
                              
                              ElevatedButton(
                                onPressed: () {
                                  // Action pour voir les détails
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text(
                                  'Voir les détails',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}