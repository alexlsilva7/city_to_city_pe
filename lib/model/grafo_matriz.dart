import 'dart:core';

import 'package:matrices/matrices.dart';

class GrafoMatriz {
  final List<String> vertices = <String>[];

  late final SquareMatrix _matriz;

  GrafoMatriz(int quantVertices) {
    _matriz = SquareMatrix.diagonalFromNumber(1, quantVertices);
  }

  @override
  String toString() {
    return _matriz.toString();
  }
}
