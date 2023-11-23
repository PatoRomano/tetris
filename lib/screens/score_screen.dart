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
        backgroundColor: Colors.black,
        title: const Text(
          'Tabla de Puntuaciones',
          style: TextStyle(
            fontFamily: 'roundedsqure',
            fontSize: 25,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(90, 33, 149, 243)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.3, 0.9],
          ),
        ),
        child: Center(
        child: scores.isEmpty
            ? Text('No hay puntuaciones disponibles')
            : ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  final score = scores[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                      title: Center(
                          child: Text(score.playerName,
                              style: const TextStyle(
                                fontFamily: 'roundedsqure',
                                fontSize: 25,
                                color: Colors.white,
                              ))),
                      subtitle: Center(
                          child: Text('Puntos: ${score.score}',
                              style: const TextStyle(
                                fontFamily: 'roundedsqure',
                                fontSize: 25,
                                color: Colors.white,
                              ))),
                    ),
                  );
                },
              ),
      )),
      backgroundColor: Colors.black,
    );
  }
}
