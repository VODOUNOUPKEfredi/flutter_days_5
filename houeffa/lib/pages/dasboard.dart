import 'package:flutter/material.dart';
import 'package:houeffa/models/logement_modele.dart';
import 'package:houeffa/services/sevice_logement.dart';


class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final LogementService logementService = LogementService();
  
  int totalLogements = 0;
  int logementsDisponibles = 0;
  int logementsReserves = 0;
  Map<String, int> repartitionParType = {};
  List<Logement> logementsRecents = [];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Charger les données pour le tableau de bord
  void _loadDashboardData() async {
    totalLogements = await logementService.getTotalLogements();
    logementsDisponibles = (await logementService.getLogementsDisponibles()) as int;
    logementsReserves = (await logementService.getLogementsReserves()) as int;
    repartitionParType = await logementService.getRepartitionParType();
    // Récupérer les logements récents
    logementService.getLogementsRecents().listen((logements) {
      setState(() {
        logementsRecents = logements;
      });
    });
    
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de Bord"),
      ),
      body: ListView(
        children: [
          // Résumé général
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DashboardCard(title: 'Logements Total', value: '$totalLogements'),
                DashboardCard(title: 'Disponibles', value: '$logementsDisponibles'),
                DashboardCard(title: 'Réservés', value: '$logementsReserves'),
              ],
            ),
          ),
          
          // Logements récents
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Logements Récents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          LogementList(logementsRecents: logementsRecents),

          // Graphique des types de logements
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Répartition par Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          LogementTypeChart(repartition: repartitionParType),

          // Notifications
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          NotificationsList(),
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;

  DashboardCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}

// Exemple de graphique
class LogementTypeChart extends StatelessWidget {
  final Map<String, int> repartition;

  LogementTypeChart({required this.repartition});
  
  get charts => null;

  @override
  Widget build(BuildContext context) {
    var data = repartition.entries
        .map((entry) => LogementType(entry.key, entry.value))
        .toList();

    var series = [
      charts.Series(
        id: 'Types de Logement',
        domainFn: (LogementType type, _) => type.name,
        measureFn: (LogementType type, _) => type.value,
        data: data,
      )
    ];

    return Container(
      height: 200,
      padding: EdgeInsets.all(8),
      child: charts.PieChart(series),
    );
  }
}

class LogementType {
  final String name;
  final int value;

  LogementType(this.name, this.value);
}

class LogementList extends StatelessWidget {
  final List<Logement> logementsRecents;

  LogementList({required this.logementsRecents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: logementsRecents.length,
      itemBuilder: (context, index) {
        final logement = logementsRecents[index];
        return ListTile(
          title: Text(logement.titre),
          subtitle: Text(logement.adresse),
        );
      },
    );
  }
}

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ListTile(title: Text('Réservation confirmée: Appartement 3 pièces')),
        ListTile(title: Text('Mise à jour de prix: Villa')),
      ],
    );
  }
}
