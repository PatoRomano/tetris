import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Tetris',
         style: TextStyle(
            fontFamily: 'roundedsqure',
            fontSize: 40,
            color: Colors.white,
          ),
         
          ),
         centerTitle: true,
         toolbarHeight: 100,
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FadeInImage(
              placeholder:  AssetImage(
                'assets/images/espacio.jpg',
              ),
              image:  AssetImage(
                'assets/images/espacio.jpg',
              )),
          const SizedBox(height: 40),
          InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameBoard()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        padding: const EdgeInsets.all(10),
        child: const Text(
          'Iniciar Juego',
          style: TextStyle(
            fontFamily: 'roundedsqure',
            fontSize: 25,
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
