// dimensiones de la grilla
int rowLenght = 10;
int colLenght = 15;

// direcciones posibles para el movimiento de las piezas
enum Direction {
  left,
  right,
  down,
}

// formas de piezas
enum Tetromino {
  L,
  J,
  I,
  O,
  S,
  Z,
  T,
}