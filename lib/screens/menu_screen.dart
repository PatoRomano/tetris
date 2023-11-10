import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tetris'),
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
          const SizedBox(height: 20),
          InkWell(
      onTap: () {
        // Navegar a la pantalla del juego
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GameBoard()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent), // Hacer el botón transparente
        ),
        padding: const EdgeInsets.all(10), // Ajusta el espaciado según tus necesidades
        child: const Text(
          'Iniciar Juego',
          style: TextStyle(
            fontFamily: 'roundedsqure', // Reemplaza 'TuFuentePixelArt' con la fuente pixel art que desees
            fontSize: 16, // Ajusta el tamaño de la fuente según tus necesidades
            color: Colors.white, // Ajusta el color del texto según tus necesidades
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
