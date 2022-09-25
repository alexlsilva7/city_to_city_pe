import 'dart:core';

import 'package:city_to_city_pe/model/algoritimo_kruskal_result.dart';
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

  AlgoritimoDeKruskalResult kruskalAlgorithm() {
    List<Set> conjuntos = [];
    List<String> arvore = [];
    double pesoArvore = 0;

    //inicializando os conjuntos
    for (String vertice in _vertices) {
      conjuntos.add({vertice});
    }

    //ordenando as arestas pelo peso
    Map<String, double> map = getTodasArestas();
    List<String> arestas = map.keys.toList();
    arestas.sort((a, b) => map[a]!.compareTo(map[b]!));

    for (String aresta in arestas) {
      //busca os dois conjuntos que contem os vertices da aresta
      Set conjuntoV1 = conjuntos
          .firstWhere((element) => element.contains(aresta.substring(0, 1)));
      Set conjuntoV2 = conjuntos
          .firstWhere((element) => element.contains(aresta.substring(1, 2)));
      //se os conjuntos forem diferentes, adiciona a aresta na arvore e junta os conjuntos
      if (conjuntoV1 != conjuntoV2) {
        //adiciona a aresta na arvore
        arvore.add(aresta);
        //soma o peso da aresta na arvore
        pesoArvore += map[aresta]!;
        //junta os conjuntos
        conjuntoV1.addAll(conjuntoV2);
        conjuntos.remove(conjuntoV2);
      }
      //Sai do algoritmo quando todos os vertices estiverem no mesmo conjunto
      if (conjuntos.length == 1) {
        break;
      }
    }

    return AlgoritimoDeKruskalResult(
        conjuntos: conjuntos, pesoArvore: pesoArvore, arvore: arvore);
  }

  @override
  String toString() {
    return _matriz.toString();
  }
}
