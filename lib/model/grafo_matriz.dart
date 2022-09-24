import 'dart:core';

import 'package:matrices/matrices.dart';

class GrafoMatriz {
  late final List<String> _vertices;

  late final SquareMatrix _matriz;

  GrafoMatriz({required List<String> vertices}) {
    _matriz = SquareMatrix.diagonalFromNumber(1, vertices.length);
    _vertices = vertices;
  }

  @override
  String toString() {
    return _matriz.toString();
  }
}
