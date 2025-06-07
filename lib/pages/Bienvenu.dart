import 'package:flutter/material.dart';
import 'package:twm/pages/Accueil.dart';
import 'package:twm/widget/footer.dart';

class Bienvenu extends StatelessWidget {
  const Bienvenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade300,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

            children: <Widget>[
              const Text(
                'Plongez dans une nouvelle ère de la visite immobilière grâce à notre application immersive en réalité virtuelle (VR) et en 3D.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30.0),

              buildFeatureRow(Icons.vrpano, 'Visites immersives en 360°', 'Déplacez-vous librement dans les propriétés grâce à une modélisation 3D réaliste et fluide.'),
              buildFeatureRow(Icons.headset, 'Compatibilité VR', 'Vivez l’expérience comme si vous étiez sur place, avec une immersion totale via votre casque VR.'),
              buildFeatureRow(Icons.filter_list, 'Filtrage intelligent', 'Recherchez des biens selon vos critères (localisation, budget, type de bien, etc.).'),
              buildFeatureRow(Icons.info, 'Annotations interactives', 'Consultez en temps réel les informations clés sur chaque pièce (superficie, matériaux, orientation).'),
              buildFeatureRow(Icons.favorite, 'Favoris & partages', 'Enregistrez vos biens préférés et partagez-les facilement avec vos proches ou votre agent immobilier.'),
              buildFeatureRow(Icons.calendar_today, 'Rendez-vous en ligne', 'Planifiez une visite physique ou une session en direct avec un conseiller, directement depuis l’application.'),

              const SizedBox(height: 30.0),

              const Text(
                'Grâce à notre technologie innovante, gagnez du temps, affinez vos choix et vivez une expérience de recherche immobilière inédite. ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
        bottomNavigationBar: const MonFooter()
    );
  }

  Widget buildFeatureRow(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: Colors.blueAccent, size: 30.0),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}