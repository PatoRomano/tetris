import 'dart:ui';

import 'package:tetris/board.dart';

import 'values.dart';

class Piece {
  Tetromino type;

  Piece({required this.type});

  List<int> position = [];

  Color get color {
    return tetrominoColors[type] ?? const Color(0xFFFFFFFF);
  }

  //crea una nueva pieza
  void initializePiece() {
    switch(type){
      case Tetromino.L:
        position = [
          -26,-16,-6,-5,
        ];
        break;
      case Tetromino.J:
        position = [
          -25,-15,-5,-6,
        ];
        break;
      case Tetromino.I:
        position = [
          -4,-5,-6,-7,
        ];
        break;
      case Tetromino.O:
        position = [
          -15,-16,-5,-6,
        ];
        break;
      case Tetromino.S:
        position = [
          -15,-14,-6,-5,
        ];
        break;
      case Tetromino.Z:
        position = [
          -17,-16,-6,-5,
        ];
        break;
      case Tetromino.T:
        position = [
          -26,-16,-6,-15,
        ];
        break;
      default:
    }
  }

  // mover una pieza.
  void movePiece(Direction direction) {
    switch (direction) {
      case Direction.down:
        for(int i = 0; i < position.length; i++) {
          position[i] += rowLenght;
        }
        break;
      case Direction.left:
        for(int i = 0; i < position.length; i++) {
          position[i] -= 1;
        }
        break;
      case Direction.right:
        for(int i = 0; i < position.length; i++) {
          position[i] += 1;
        }
        break;
      default:
    }
  }

  // a partir de aca empieza la logica de rotar las piezas
  // cada pieza se rota de manera diferente ya que tienen distintas formas.
  // todas las piezas poseen un pivot, es decir giran sobre un eje,
  // ese pivot va a ser el pixel que no se mueva, va a permanecer igual.
  // los demas van a cambiar su posicion respecto a el.
  // luego hay que tener en cuenta que cada pieza tiene un estado de rotacion,
  // y en total son 4, puede estar en su posicion inicial, o rotada 3 veces.
  // todas las piezas rotan en sentido horario.
  // la unica pieza que no rota es el cuadrado "O"
  //
  int rotationState = 1;
  void rotatePiece () {
    List<int> newPosition = [];

    //rota la pieza en base al tipo
    switch (type) {
      case Tetromino.L:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLenght,
              position[1],
              position[1] + rowLenght,
              position[1] + rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLenght - 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLenght,
              position[1],
              position[1] - rowLenght,
              position[1] - rowLenght - 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] - rowLenght + 1,
              position[1],
              position[1] + 1,
              position[1] - 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;


      case Tetromino.J:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - rowLenght,
              position[1],
              position[1] + rowLenght,
              position[1] + rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLenght - 1,
              position[1],
              position[1] - 1,
              position[1] + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + rowLenght,
              position[1],
              position[1] - rowLenght,
              position[1] - rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] + rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
      break;


      case Tetromino.I:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + 2,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - rowLenght,
              position[1],
              position[1] + rowLenght,
              position[1] + 2 * rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] + 1,
              position[1],
              position[1] - 1,
              position[1] - 2,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[1] + rowLenght,
              position[1],
              position[1] - rowLenght,
              position[1] - 2 * rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;


      case Tetromino.S:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLenght - 1,
              position[1] + rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLenght,
              position[0],
              position[0] + 1,
              position[0] + rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1],
              position[1] + 1,
              position[1] + rowLenght - 1,
              position[1] + rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLenght,
              position[0],
              position[0] + 1,
              position[0] + rowLenght + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;


      case Tetromino.Z:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[0] + rowLenght - 2,
              position[1],
              position[2] + rowLenght - 1,
              position[3] + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[0] - rowLenght + 2,
              position[1],
              position[2] - rowLenght + 1,
              position[3] - 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[0] + rowLenght - 2,
              position[1],
              position[2] + rowLenght - 1,
              position[3] + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[0] - rowLenght + 2,
              position[1],
              position[2] - rowLenght + 1,
              position[3] - 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;


      case Tetromino.T:
        switch (rotationState) {
          case 0:
            newPosition = [
              position[2] - rowLenght,
              position[2],
              position[2] + 1,
              position[2] + rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 1:
            newPosition = [
              position[1] - 1,
              position[1],
              position[1] + 1,
              position[1] + rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 2:
            newPosition = [
              position[1] - rowLenght,
              position[1] - 1,
              position[1],
              position[1] + rowLenght,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
          case 3:
            newPosition = [
              position[2] - rowLenght,
              position[2] - 1,
              position[2],
              position[2] + 1,
            ];
            if(piecePositionIsValid(newPosition)) {
              position = newPosition;
              rotationState = (rotationState + 1) % 4;
            }
            break;
        }
        break;

      default:
    }
  }

  // verifica si la posicion dada por parametro es valida o no
  // o si esta ocupada por otra pieza que ya cayó.
  bool positionIsValid(int position) {
    int row = (position/rowLenght).floor();
    int col = position % rowLenght;

    if (row < 0 || col < 0 || gameBoard[row][col] != null) {
      return false;
    } else {
      return true;
    }
  }

  // verifica si la posicion que va a ocupar cada pixel de la pieza
  // que estoy moviendo es valida o no.
  bool piecePositionIsValid(List<int> piecePosition) {
    bool firstColOcuppied = false;
    bool lastColOccupied = false;

    for(int pos in piecePosition) {
      if (!positionIsValid(pos)) {
        return false;
      }

      int col = pos % rowLenght;

      if(col == 0) {
        firstColOcuppied = true;
      }
      if(col == rowLenght - 1) {
        lastColOccupied = true;
      }
    }

    return !(firstColOcuppied && lastColOccupied);
  }
}

// color asignado a cada pieza
const Map<Tetromino, Color> tetrominoColors = {
  Tetromino.L: Color.fromARGB(255, 255, 120, 39),
  Tetromino.J: Color.fromARGB(255, 57, 81, 255),
  Tetromino.I: Color.fromARGB(255, 252, 120, 229),
  Tetromino.O: Color.fromARGB(255, 224, 177, 35),
  Tetromino.S: Color.fromARGB(255, 92, 175, 53),
  Tetromino.Z: Color.fromARGB(255, 227, 72, 72),
  Tetromino.T: Color.fromARGB(255, 158, 63, 218),
};