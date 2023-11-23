import 'package:flutter/material.dart';
import 'package:tetris/controllers/ScoreController.dart';

class ScoreboardScreen extends StatefulWidget {
  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  final scoreManager = ScoreManager();
  late List<Score> scores = [];

  @override
  void initState() {
    super.initState();
    loadScores();
  }

  Future<void> loadScores() async {
    
    scores = await scoreManager.readScores();
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabla de Puntuaciones'),
      ),
      body: scores.isEmpty
          ? const Center(
              child: Text('No hay puntuaciones disponibles'),
            )
          : Center(child: ListView.builder(
              itemCount: scores.length,
              itemBuilder: (context, index) {
                final score = scores[index];
                return ListTile(
                  title: Text(score.playerName),
                  subtitle: Text('Puntos: ${score.score}'),
                );
              },
            ),
    ));
  }
}
