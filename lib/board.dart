import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundpool/soundpool.dart';
import 'package:tetris/controllers/ScoreController.dart';
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
  bool pause = false;
  String nombre = "Player";

  late final Soundpool _soundpool;

  Duration frameRate = const Duration(milliseconds: 500);

  String difficulty = 'Fácil';
  late final AudioPlayer _audioPlayer = AudioPlayer();
  late final AudioPlayer _gameOver = AudioPlayer();
  late final AudioPlayer _pop = AudioPlayer();
  late final AudioPlayer _pick = AudioPlayer();
  late Timer gameTimer;
  final scoreManager = ScoreManager();
  @override
  void initState() {
    super.initState();
    _audioPlayer.setAsset('assets/sounds/musica.mp3');
    _gameOver.setAsset('assets/sounds/sad-violin.mp3');
    _pop.setAsset('assets/sounds/pop.mp3');
    _pick.setAsset('assets/sounds/pick.mp3');
    _soundpool = Soundpool(streamType: StreamType.music);

    startGame();
  }

  Future<void> _soundmovepiece() async {
    int soundId = await rootBundle
        .load("assets/sounds/minecraft_click.mp3")
        .then((ByteData soundData) {
      return _soundpool.load(soundData);
    });
    int streamId = await _soundpool.play(soundId);
  }

  Future<void> _soundClearLines() async {
    int soundId = await rootBundle
        .load("assets/sounds/pop.mp3")
        .then((ByteData soundData) {
      return _soundpool.load(soundData);
    });
    int streamId = await _soundpool.play(soundId);
  }

  Future<void> updateScores() async {
    late List<Score> scoresList = [];
    final scores = await scoreManager.readScores();
    scoresList = scores;
    scores.add(Score(id:scoresList.length + 1,playerName: nombre, score: currentScore));
    await scoreManager.writeScores(scores);
  }

  void startGame() {
    _audioPlayer.setSpeed(1);
    _audioPlayer.setVolume(0.1);
    _gameOver.setVolume(0.1);
    frameRate = const Duration(milliseconds: 500);
    nombre = "";
    currentScore = 0;
    volver = false;
    gameOver = false;
    pause = false;

    currentPiece.initializePiece();
    _audioPlayer.play();

    gameLoop();
  }

  void gameLoop() {
    gameTimer = Timer.periodic(frameRate, (timer) {
      setState(() {
        increaseDifficulty();
        clearLines();
        checkLanding();
        if (gameOver || pause) {
          if (gameOver && !pause) {
            _gameOver.play();
            _audioPlayer.seek(Duration.zero, index: 2);
          }
          _audioPlayer.stop();
          showGameOverDialog();
        } else {
          currentPiece.movePiece(Direction.down);
        }
      });
    });
  }

  void increaseDifficulty() {
    if (currentScore <= 100) {
      frameRate = const Duration(milliseconds: 500);
      difficulty = 'Fácil';
    } else if (currentScore == 300) {
      frameRate = const Duration(milliseconds: 400);
      _audioPlayer.setSpeed(1.2);
      difficulty = 'Media';
    } else if (currentScore >= 300) {
      frameRate = const Duration(milliseconds: 300);
      _audioPlayer.setSpeed(1.3);
      difficulty = 'Difícil';
    }
    //gameTimer.cancel();
    //gameLoop();
  }

  void showGameOverDialog() async {
    nombre = "Player";
    gameTimer.cancel();
    if (currentScore != 0) {
      await _preguntarNombre();
      await updateScores();
    }
    if (gameOver && !volver && !pause) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Game Over',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          content: Text(
            'Tu puntaje alcanzado es:  $currentScore',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // restart
                  resetGame();
                  _gameOver.stop();
                  _gameOver.seek(Duration.zero, index: 2);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Jugar de nuevo',
                  style: TextStyle(fontSize: 18, fontFamily: 'roundedsqure'),
                )),
          ],
        ),
      );
    } else if (volver) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Game Over',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          content: Text(
            'Tu puntaje alcanzado es:  $currentScore',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // restart
                  Navigator.pop(context);
                },
                child: const Text(
                  'Ok',
                  style: TextStyle(fontSize: 18, fontFamily: 'roundedsqure'),
                )),
          ],
        ),
      );
      endGame();
    } else if (pause) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Pausa',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          content: Text(
            'Tu puntaje alcanzado es:  $currentScore',
            style: const TextStyle(
                fontSize: 18, color: Colors.white, fontFamily: 'roundedsqure'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  // restart
                  continueGame();
                  Navigator.pop(context);
                },
                child: const Text(
                  'Reanudar',
                  style: TextStyle(fontSize: 18, fontFamily: 'roundedsqure'),
                )),
          ],
        ),
      );
    }
  }

  Future<void> _preguntarNombre() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Ingresa tu nombre',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontFamily: 'roundedsqure',
            ),
          ),
          content: SingleChildScrollView(child:Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    nombre = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Nombre',
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: nombre.isNotEmpty
                    ? () {
                        Navigator.pop(context); // Cierra el cuadro de diálogo
                      }
                    : null,
                child: const Text(
                  'Aceptar',
                  style: TextStyle(fontSize: 18, fontFamily: 'roundedsqure'),
                ),
              ),
            ],
          ),
        ));
      },
    );
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
    if (!volver) {
      createNewPiece();

      startGame();
    }
  }

  void continueGame() {
    pause = false;
    _audioPlayer.play();
    gameLoop();
  }

  void endGame() {
    //limpiar el tablero
    gameBoard = List.generate(
      colLenght,
      (i) => List.generate(
        rowLenght,
        (j) => null,
      ),
    );
    gameOver = false;
    volver = false;
    pause = false;
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

  void dropPiece() {
    _soundmovepiece();
    setState(() {
      while (!checkCollision(Direction.down)) {
        currentPiece.movePiece(Direction.down);
      }
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
        _soundClearLines();
        // mover todas las filas hhacia abajo
        for (int r = row; r > 0; r--) {
          // copia la fila superior, a la fila actual, es decir, digamos, osea, copia tal cual esta a la de abajo.
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }

        // setear la fila superior a vacia.
        gameBoard[0] = List.generate(rowLenght, (index) => null);

        // incrementar el puntaje.
        currentScore += 100;
        //_pick.play();
        //_pop.stop();
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
                    fontFamily: 'roundedsqure',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10.0),
              child: TextButton(
                onPressed: () {
                  // restart
                  pause = true;
                },
                child: const Text(
                  'Pausa',
                  style: TextStyle(
                    fontFamily: 'roundedsqure',
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10.0),
              child: InkWell(
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
                    border: Border.all(color: Colors.transparent),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    'Volver',
                    style: TextStyle(
                      fontFamily: 'roundedsqure',
                      fontSize: 18,
                      color: Colors.white,
                    ),
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
                style: const TextStyle(
                  fontFamily: 'roundedsqure',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                'Dificultad:  $difficulty',
                style: const TextStyle(
                  fontFamily: 'roundedsqure',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                  onPressed: dropPiece,
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_downward)),
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
                    icon: const Icon(Icons.arrow_back_ios_new)),
                // rotar
                IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right)),
                //derecha
                IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
