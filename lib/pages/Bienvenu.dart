import 'package:flutter/material.dart';
import 'package:twm/widget/footer.dart';

class Bienvenu extends StatefulWidget {
  const Bienvenu({super.key});

  @override
  State<Bienvenu> createState() => _BienvenuState();
}

class _BienvenuState extends State<Bienvenu> with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  final List<Map<String, dynamic>> _features = [
    {
      "icon": Icons.vrpano,
      "title": "Visites immersives en 360°",
      "description":
      "Déplacez-vous librement dans les propriétés grâce à une modélisation 3D réaliste et fluide."
    },
    {
      "icon": Icons.headset,
      "title": "Compatibilité VR",
      "description":
      "Vivez l’expérience comme si vous étiez sur place, avec une immersion totale via votre casque VR."
    },
    {
      "icon": Icons.filter_list,
      "title": "Filtrage intelligent",
      "description":
      "Recherchez des biens selon vos critères (localisation, budget, type de bien, etc.)."
    },
    {
      "icon": Icons.info,
      "title": "Annotations interactives",
      "description":
      "Consultez en temps réel les informations clés sur chaque pièce (superficie, matériaux, orientation)."
    },
    {
      "icon": Icons.favorite,
      "title": "Favoris & partages",
      "description":
      "Enregistrez vos biens préférés et partagez-les facilement avec vos proches ou votre agent immobilier."
    },
    {
      "icon": Icons.calendar_today,
      "title": "Rendez-vous en ligne",
      "description":
      "Planifiez une visite physique ou une session en direct avec un conseiller, directement depuis l’application."
    },
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _features.length,
          (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      ),
    );

    _animations = _controllers
        .map((controller) => Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    ))
        .toList();

    _startAnimations();
  }

  Future<void> _startAnimations() async {
    for (int i = 0; i < _controllers.length; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      _controllers[i].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildFeatureAnimated(int index) {
    final feature = _features[index];
    return SlideTransition(
      position: _animations[index],
      child: buildFeatureRow(
        feature['icon'],
        feature['title'],
        feature['description'],
      ),
    );
  }

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Plongez dans une nouvelle ère de la visite immobilière grâce à notre application immersive en réalité virtuelle (VR) et en 3D.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30.0),

              ...List.generate(_features.length, _buildFeatureAnimated),

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
      bottomNavigationBar: const MonFooter(),
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
