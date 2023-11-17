import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/screens/menu_screen.dart';
import 'package:tetris/values.dart';

List<List<Tetromino?>> gameBoard = List.generate(
  colLenght,
  (i) => List.generate(
    rowLenght,
    (j) => null,
  ),
);

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  Piece currentPiece = Piece(type: Tetromino.L);

  int currentScore = 0;

  bool gameOver = false;
  bool volver = false;
  Duration frameRate = const Duration(milliseconds: 500);

  String difficulty = 'Fácil';
  late final AudioPlayer _audioPlayer = AudioPlayer();
  late final AudioPlayer _gameOver = AudioPlayer();
  late final AudioPlayer _pick = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _audioPlayer.setAsset('assets/sounds/musica.mp3');
    _gameOver.setAsset('assets/sounds/sad-trumpet.mp3');
    _pick.setAsset('assets/sounds/pick.mp3');
    startGame();
  }

  Future<void> _soundmovepiece() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle
        .load("assets/sounds/Tetris-block-move-sound-effect.mp3")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  void startGame() {
    currentPiece.initializePiece();
    _audioPlayer.play();

    gameLoop();
  }

  void gameLoop() {
    Timer.periodic(frameRate, (timer) {
      setState(() {
        increaseDifficulty();
        clearLines();
        checkLanding();
        if (gameOver) {
          _gameOver.play();
          _audioPlayer.seek(Duration.zero, index: 2);
          _audioPlayer.stop();
          timer.cancel();
          showGameOverDialog();
          currentScore = 0;
        }
        currentPiece.movePiece(Direction.down);
      });
    });
  }

  void increaseDifficulty() {
    if (currentScore < 100) {
      frameRate = const Duration(milliseconds: 500);
    } else if (currentScore > 200 && currentScore <= 300) {
      frameRate = const Duration(milliseconds: 300);
    }else{
      frameRate = const Duration(milliseconds: 100);
    }
    checkDifficulty();
  }

  void checkDifficulty() {
    if (frameRate >= const Duration(milliseconds: 500)) {
      difficulty = 'Fácil';
    } else if (frameRate == const Duration(milliseconds: 300)) {
      _audioPlayer.setSpeed(1.2);
      difficulty = 'Media';
    } else if (frameRate < const Duration(milliseconds: 100)) {
      _audioPlayer.setSpeed(1.5);
      difficulty = 'Difícil';
    }
  }

  void showGameOverDialog() {
    if (!volver) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Game Over'),
          content: Text('Tu puntaje alcanzado es:  $currentScore'),
          actions: [
            TextButton(
                onPressed: () {
                  // restart
                  resetGame();
                  Navigator.pop(context);
                },
                child:const Text('Jugar de nuevo')),
          ],
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title:const Text('Game Over'),
                content: Text('Tu puntaje alcanzado es:  $currentScore'),
              ));
    }
  }

  void resetGame() {
    //limpiar el tablero
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLenght,
        (j) => null,
      ),
    );

    gameOver = false;
    currentScore = 0;

    createNewPiece();

    startGame();
  }

  bool checkCollision(Direction direction) {
    // recorre cada posicion de la pieza actual x d
    for (int i = 0; i < currentPiece.position.length; i++) {
      //calcula la fila y columna.
      int row = (currentPiece.position[i] / rowLenght).floor();
      int col = (currentPiece.position[i] % rowLenght);

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLenght || col < 0 || col >= rowLenght) {
        return true;
      }
      if (row < colLenght && row >= 0 && gameBoard[row][col] != null) {
        return true; // collision with a landed piece
      }
    }
    return false;
  }

  void checkLanding() {
    if (checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLenght).floor();
        int col = currentPiece.position[i] % rowLenght;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();

    Tetromino randomType =
        Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    // en lugar de chequear cada frame, se chequea al crear una nueva pieza, para ver si la fila de arriba esta ocupada.
    if (isGameOver()) {
      gameOver = true;
    }
  }

  void moveLeft() {
    _soundmovepiece();
    // asegurarse que el movimiento es valido antes de moverlo
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    _soundmovepiece();
    // asegurarse que el movimiento es valido antes de moverlo
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    _soundmovepiece();
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  // eliminar una linea completa
  void clearLines() {
    // recorrer cada fila de abajo arriba.

    for (int row = colLenght - 1; row >= 0; row--) {
      // inicializar una variable para rastrear si la fila esta completa.
      bool rowIsFull = true;

      // verifica si la fila esta completa
      for (int col = 0; col < rowLenght; col++) {
        // si hay una sola columna vacia, retorna falso
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // si esta llena, eliminar la fila y bajar las piezas una fila
      if (rowIsFull) {
        // mover todas las filas hhacia abajo
        for (int r = row; r > 0; r--) {
          // copia la fila superior, a la fila actual, es decir, digamos, osea, copia tal cual esta a la de abajo.
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // setear la fila superior a vacia.
        gameBoard[0] = List.generate(row, (index) => null);

        // incrementar el puntaje.
        currentScore += 100;
        _pick.play();
      }
    }
  }

  // GAME OVER
  bool isGameOver() {
    for (int col = 0; col < rowLenght - 1; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10.0),
              child: TextButton(
                onPressed: () {
                  // restart
                  gameOver = true;
                },
                child: const Text(
                  'Reiniciar',
                  style: TextStyle(
                    fontFamily:
                        'roundedsqure', // Reemplaza 'TuFuentePixelArt' con la fuente pixel art que desees
                    fontSize:
                        16, // Ajusta el tamaño de la fuente según tus necesidades
                    color: Colors
                        .white, // Ajusta el color del texto según tus necesidades
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                volver = true;
                gameOver = true;
                // Navegar a la pantalla del juego
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.transparent), // Hacer el botón transparente
                ),
                padding: const EdgeInsets.all(
                    10), // Ajusta el espaciado según tus necesidades
                child: const Text(
                  'Volver',
                  style: TextStyle(
                    fontFamily:
                        'roundedsqure', // Reemplaza 'TuFuentePixelArt' con la fuente pixel art que desees
                    fontSize:
                        16, // Ajusta el tamaño de la fuente según tus necesidades
                    color: Colors
                        .white, // Ajusta el color del texto según tus necesidades
                  ),
                ),
              ),
            ),
          ]),

          //GRILLA DEL JUEGO
          Expanded(
            child: GridView.builder(
                itemCount: rowLenght * colLenght,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowLenght),
                itemBuilder: (context, index) {
                  int row = (index / rowLenght).floor();
                  int col = index % rowLenght;
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                    );
                  } else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                      color: tetrominoColors[tetrominoType],
                    );
                  } else {
                    return Pixel(
                      color: Colors.grey[900],
                    );
                  }
                }),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Puntaje:  $currentScore',
                style:const TextStyle(color: Colors.white),
              ),
              Text(
                'Dificultad:  $difficulty',
                style:const TextStyle(color: Colors.white),
              ),
            ],
          ),

          // CONTROLADORES DEL JUEGO
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // izquierda
                IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon:const Icon(Icons.arrow_back_ios_new)),
                // rotar
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon:const Icon(Icons.rotate_right)),
                //derecha
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon:const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
