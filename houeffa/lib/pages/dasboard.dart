// import 'package:flutter/material.dart';
// import 'package:houeffa/models/logement_modele.dart';
// import 'package:houeffa/services/sevice_logement.dart';


// class DashboardPage extends StatefulWidget {
//   @override
//   _DashboardPageState createState() => _DashboardPageState();
// }

// class _DashboardPageState extends State<DashboardPage> {
//   final LogementService logementService = LogementService();
  
//   int totalLogements = 0;
//   int logementsDisponibles = 0;
//   int logementsReserves = 0;
//   Map<String, int> repartitionParType = {};
//   List<Logement> logementsRecents = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadDashboardData();
//   }

//   // Charger les données pour le tableau de bord
//   void _loadDashboardData() async {
//     totalLogements = await logementService.getTotalLogements();
//     logementsDisponibles = (await logementService.getLogementsDisponibles()) as int;
//     logementsReserves = (await logementService.getLogementsReserves()) as int;
//     repartitionParType = await logementService.getRepartitionParType();
//     // Récupérer les logements récents
//     logementService.getLogementsRecents().listen((logements) {
//       setState(() {
//         logementsRecents = logements;
//       });
//     });
    
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Tableau de Bord"),
//       ),
//       body: ListView(
//         children: [
//           // Résumé général
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 DashboardCard(title: 'Logements Total', value: '$totalLogements'),
//                 DashboardCard(title: 'Disponibles', value: '$logementsDisponibles'),
//                 DashboardCard(title: 'Réservés', value: '$logementsReserves'),
//               ],
//             ),
//           ),
          
//           // Logements récents
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text('Logements Récents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ),
//           LogementList(logementsRecents: logementsRecents),

//           // Graphique des types de logements
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text('Répartition par Type', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ),
//           LogementTypeChart(repartition: repartitionParType),

//           // Notifications
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           ),
//           NotificationsList(),
//         ],
//       ),
//     );
//   }
// }

// class DashboardCard extends StatelessWidget {
//   final String title;
//   final String value;

//   DashboardCard({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text(value, style: TextStyle(fontSize: 24)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Exemple de graphique
// class LogementTypeChart extends StatelessWidget {
//   final Map<String, int> repartition;

//   LogementTypeChart({required this.repartition});
  
//   get charts => null;

//   @override
//   Widget build(BuildContext context) {
//     var data = repartition.entries
//         .map((entry) => LogementType(entry.key, entry.value))
//         .toList();

//     var series = [
//       charts.Series(
//         id: 'Types de Logement',
//         domainFn: (LogementType type, _) => type.name,
//         measureFn: (LogementType type, _) => type.value,
//         data: data,
//       )
//     ];

//     return Container(
//       height: 200,
//       padding: EdgeInsets.all(8),
//       child: charts.PieChart(series),
//     );
//   }
// }

// class LogementType {
//   final String name;
//   final int value;

//   LogementType(this.name, this.value);
// }

// class LogementList extends StatelessWidget {
//   final List<Logement> logementsRecents;

//   LogementList({required this.logementsRecents});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       itemCount: logementsRecents.length,
//       itemBuilder: (context, index) {
//         final logement = logementsRecents[index];
//         return ListTile(
//           title: Text(logement.titre),
//           subtitle: Text(logement.adresse),
//         );
//       },
//     );
//   }
// }

// class NotificationsList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       shrinkWrap: true,
//       children: [
//         ListTile(title: Text('Réservation confirmée: Appartement 3 pièces')),
//         ListTile(title: Text('Mise à jour de prix: Villa')),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Utilisation de fl_chart au lieu de charts_flutter
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  // Charger les données pour le tableau de bord
  void _loadDashboardData() async {
    try {
      totalLogements = await logementService.getTotalLogements();
      logementsDisponibles = await logementService.getLogementsDisponibles() as int;
      logementsReserves = await logementService.getLogementsReserves() as int;
      repartitionParType = await logementService.getRepartitionParType();
      
      // Récupérer les logements récents
      logementService.getLogementsRecents().listen((logements) {
        if (mounted) {
          setState(() {
            logementsRecents = logements;
            isLoading = false;
          });
        }
      });
      
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erreur chargement dashboard: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tableau de Bord"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _loadDashboardData();
            },
          ),
        ],
      ),
      body: isLoading 
        ? Center(child: CircularProgressIndicator()) 
        : RefreshIndicator(
          onRefresh: () async {
            setState(() {
              isLoading = true;
            });
            _loadDashboardData();
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // Résumé général
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DashboardCard(
                    title: 'Logements Total',
                    value: '$totalLogements',
                    color: Colors.blue,
                    icon: Icons.home,
                  ),
                  DashboardCard(
                    title: 'Disponibles',
                    value: '$logementsDisponibles',
                    color: Colors.green,
                    icon: Icons.check_circle,
                  ),
                  DashboardCard(
                    title: 'Réservés',
                    value: '$logementsReserves',
                    color: Colors.orange,
                    icon: Icons.bookmark,
                  ),
              ],
            ),
              
              SizedBox(height: 24),
              
              // Graphique des types de logements
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Répartition par Type',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 250,
                        child: LogementTypeChart(repartition: repartitionParType),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Tendance des réservations (graphique linéaire)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tendance des Réservations',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Container(
                        height: 200,
                        child: ReservationTrendChart(),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Logements récents
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logements Récents',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      LogementList(logementsRecents: logementsRecents),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              // Notifications
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notifications',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      NotificationsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  DashboardCard({
    required this.title, 
    required this.value, 
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              title, 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              value, 
              style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

// Graphique en camembert pour les types de logements
class LogementTypeChart extends StatelessWidget {
  final Map<String, int> repartition;

  LogementTypeChart({required this.repartition});

  List<Color> colorList = [
    Colors.blue, 
    Colors.red, 
    Colors.green, 
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    // Si pas de données, afficher un message
    if (repartition.isEmpty) {
      return Center(child: Text('Aucune donnée disponible'));
    }

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: _createSections(),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              startDegreeOffset: 180,
            ),
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _createLegendItems(),
        ),
      ],
    );
  }

  List<PieChartSectionData> _createSections() {
    final List<PieChartSectionData> sections = [];
    int colorIndex = 0;
    
    repartition.forEach((type, count) {
      final color = colorList[colorIndex % colorList.length];
      colorIndex++;
      
      sections.add(
        PieChartSectionData(
          value: count.toDouble(),
          title: '$count',
          radius: 50,
          titleStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          color: color,
        ),
      );
    });
    
    return sections;
  }

  List<Widget> _createLegendItems() {
    final List<Widget> legends = [];
    int colorIndex = 0;
    
    repartition.forEach((type, count) {
      final color = colorList[colorIndex % colorList.length];
      colorIndex++;
      
      legends.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
            ),
            SizedBox(width: 4),
            Text(
              type,
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    });
    
    return legends;
  }
}

// Graphique de tendance des réservations
class ReservationTrendChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Données simulées pour l'exemple
    // Dans une application réelle, ces données proviendraient de votre service
    final List<Map<String, dynamic>> data = [
      {'month': 'Jan', 'count': 5},
      {'month': 'Fév', 'count': 7},
      {'month': 'Mar', 'count': 10},
      {'month': 'Avr', 'count': 8},
      {'month': 'Mai', 'count': 12},
      {'month': 'Juin', 'count': 15},
    ];

    return LineChart(
      LineChartData(
        gridData: FlGridData(show: true),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Text(data[index]['month'], style: TextStyle(fontSize: 10));
                }
                return Text('');
              },
              reservedSize: 22,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              getTitlesWidget: (value, meta) {
                return Text('${value.toInt()}', style: TextStyle(fontSize: 10));
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: true),
        minX: 0,
        maxX: data.length - 1.0,
        minY: 0,
        maxY: data.map((e) => e['count'] as int).reduce((a, b) => a > b ? a : b) * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: List.generate(
              data.length,
              (index) => FlSpot(index.toDouble(), data[index]['count'].toDouble()),
            ),
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.2)),
          ),
        ],
      ),
    );
  }
}

class LogementList extends StatelessWidget {
  final List<Logement> logementsRecents;

  LogementList({required this.logementsRecents});

  @override
  Widget build(BuildContext context) {
    if (logementsRecents.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(child: Text('Aucun logement récent')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: logementsRecents.length > 5 ? 5 : logementsRecents.length,
      itemBuilder: (context, index) {
        final logement = logementsRecents[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.withOpacity(0.2),
            child: Icon(Icons.home, color: Colors.blue),
          ),
          title: Text(
            logement.titre,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(logement.adresse),
          trailing: Text(
            logement.disponible ? 'Disponible' : 'Réservé',
            style: TextStyle(
              color: logement.disponible ? Colors.green : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class NotificationsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Exemple de notifications, dans une application réelle, ces données proviendraient de votre service
    final notifications = [
      {'message': 'Réservation confirmée: Appartement 3 pièces', 'time': 'Il y a 2h', 'icon': Icons.check_circle, 'color': Colors.green},
      {'message': 'Mise à jour de prix: Villa', 'time': 'Il y a 5h', 'icon': Icons.attach_money, 'color': Colors.orange},
      {'message': 'Nouveau logement ajouté', 'time': 'Hier', 'icon': Icons.add_home, 'color': Colors.blue},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: notification['color'] as Color,
            child: Icon(notification['icon'] as IconData, color: Colors.white, size: 20),
          ),
          title: Text(notification['message'] as String),
          subtitle: Text(notification['time'] as String),
        );
      },
    );
  }
}