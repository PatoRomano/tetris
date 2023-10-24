import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:flutter/src/rendering/sliver_grid.dart';
import 'package:tetris/piece.dart';
import 'package:tetris/pixel.dart';
import 'package:tetris/values.dart';


List<List<Tetromino?>> gameBoard = List.generate(
    colLenght,
        (i) => List.generate(
          rowLenght,
            (j) => null,
        )
);


class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {

  Piece currentPiece = Piece(type: Tetromino.L);

  @override
  void initState() {
    super.initState();

    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    Duration frameRate = const Duration(milliseconds: 800);
    gameLoop(frameRate);
  }

  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        setState(() {

          checkLanding();
          currentPiece.movePiece(Direction.down);
        });
      }
    );
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
    }
    return false;
  }

  void checkLanding() {
    if(checkCollision(Direction.down)) {
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLenght).floor();
        int col = currentPiece.position[i] % rowLenght;
        if(row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      createNewPiece();
    }
  }

  void createNewPiece() {
    Random rand = Random();

    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GridView.builder(
          itemCount: rowLenght * colLenght,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowLenght),
          itemBuilder: (context, index) {
            int row = (index / rowLenght).floor();
            int col = index % rowLenght;
            if (currentPiece.position.contains(index)){
              return Pixel(
                color: Colors.yellow,
                child: index,
              );

            } else if (gameBoard[row][col] != null){
              return Pixel(color: Colors.pink, child: '');

            } else {
              return Pixel(
                color: Colors.grey[900],
                child: index,
              );
            }
          }
      ),
    );
  }
}
