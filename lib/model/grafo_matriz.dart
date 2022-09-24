import 'dart:core';

import 'package:matrices/matrices.dart';

class GrafoMatriz {
  late final List<String> _vertices;

  late final SquareMatrix _matriz;

  GrafoMatriz({required List<String> vertices}) {
    _matriz = SquareMatrix.diagonalFromNumber(1, vertices.length);
    _vertices = vertices;
  }

  void addAresta(String v1, String v2, double peso) {
    int posV1 = _vertices.indexOf(v1);
    int posV2 = _vertices.indexOf(v2);

    if (posV1 != -1 && posV2 != -1) {
      _matriz.matrix[posV1][posV2] = peso;
      _matriz.matrix[posV2][posV1] = peso;
    }
  }

  @override
  String toString() {
    return _matriz.toString();
  }
}
