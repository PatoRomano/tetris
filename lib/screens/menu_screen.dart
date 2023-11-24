import 'package:flutter/material.dart';
import 'package:tetris/board.dart';
import 'package:tetris/screens/score_screen.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/galaxy.jpg',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.5),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameBoard()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Iniciar Juego',
                    style: TextStyle(
                      fontFamily: 'roundedsqure',
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Otro espacio entre los botones
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ScoreboardScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Puntuaciones',
                    style: TextStyle(
                      fontFamily: 'roundedsqure',
                      fontSize: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Tetris',
                style: TextStyle(
                  fontFamily: 'roundedsqure',
                  fontSize: 72,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black12,
    );
  }
}
