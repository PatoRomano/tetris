import 'package:flutter/material.dart';
import 'package:tetris/board.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Tetris',
         style: TextStyle(
            fontFamily: 'roundedsqure', // Reemplaza 'TuFuentePixelArt' con la fuente pixel art que desees
            fontSize: 40, // Ajusta el tamaño de la fuente según tus necesidades
            color: Colors.white, // Ajusta el color del texto según tus necesidades
          ),
         
          ),
         centerTitle: true,
         toolbarHeight: 100,
        backgroundColor: Colors.black,
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
            fontSize: 25, // Ajusta el tamaño de la fuente según tus necesidades
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
