import 'dart:core';

import 'package:city_to_city_pe/model/dijkstra_result.dart';
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

  int getIndexVertice(String vertice) {
    return _vertices.indexOf(vertice);
  }

  String getVerticeByIndex(int index) {
    return _vertices[index];
  }

  List<String> getVerticesConectados(String vertice) {
    int posVertice = _vertices.indexOf(vertice);
    List<String> verticesConectados = [];
    for (int i = 0; i < _vertices.length; i++) {
      if (_matriz.matrix[posVertice][i] > 0 && posVertice != i) {
        verticesConectados.add(_vertices[i]);
      }
    }
    return verticesConectados;
  }

  Map<String, double> getTodasArestas() {
    Map<String, double> arestas = {};
    for (int i = 0; i < _vertices.length; i++) {
      for (int j = 0; j < _vertices.length; j++) {
        if (_matriz.matrix[i][j] > 0 &&
            i != j &&
            !arestas.containsKey("${_vertices[j]}${_vertices[i]}")) {
          arestas.putIfAbsent(
              "${_vertices[i]}${_vertices[j]}", () => _matriz.matrix[i][j]);
        }
      }
    }
    return arestas;
  }

  @override
  String toString() {
    return _matriz.toString();
  }

  int _getMenorDistanciaVerticeInexplorado(
      List<double> dist, List<bool> visitados) {
    // Initialize min value
    double min = double.infinity;
    int minIndex = -1;

    for (int v = 0; v < _vertices.length; v++) {
      if (visitados[v] == false && dist[v] <= min) {
        min = dist[v];
        minIndex = v;
      }
    }

    return minIndex;
  }

  DijkstraResult dijkstra(String verticeInicial, String verticeFinal) {
    int posVerticeInicial = _vertices.indexOf(verticeInicial);
    List<double> distancias = [];
    List<bool> visitados = [];
    List<int> anteriores = [];

    // Inicializa as listas
    for (int i = 0; i < _vertices.length; i++) {
      distancias.add(double.infinity);
      visitados.add(false);
      anteriores.add(-1);
    }
    // Distancia do vertice inicial = 0;
    distancias[posVerticeInicial] = 0;
    // Encontra o menor caminho para todos os vertices
    while (visitados[_vertices.indexOf(verticeFinal)] == false) {
      int indexMenorVerticeInexplorado =
          _getMenorDistanciaVerticeInexplorado(distancias, visitados);
      visitados[indexMenorVerticeInexplorado] = true;
      for (int v = 0; v < _vertices.length; v++) {
        if (!visitados[v] &&
            _matriz.matrix[indexMenorVerticeInexplorado][v] > 0 &&
            distancias[indexMenorVerticeInexplorado] != double.infinity &&
            distancias[indexMenorVerticeInexplorado] +
                    _matriz.matrix[indexMenorVerticeInexplorado][v] <
                distancias[v]) {
          distancias[v] = distancias[indexMenorVerticeInexplorado] +
              _matriz.matrix[indexMenorVerticeInexplorado][v];
          anteriores[v] = indexMenorVerticeInexplorado;
        }
      }
    }

    return DijkstraResult(
        distancias: distancias,
        anteriores: anteriores,
        vertices: _vertices,
        indexVerticeFinal: _vertices.indexOf(verticeFinal));
  }
}
