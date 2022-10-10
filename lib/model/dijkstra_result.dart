class DijkstraResult {
  final List<double> distancias;
  final List<int> anteriores;
  final List<String> vertices;
  int indexVerticeFinal;

  DijkstraResult({
    required this.distancias,
    required this.anteriores,
    required this.indexVerticeFinal,
    required this.vertices,
  });

  List<String> _getCaminho() {
    final List<String> caminhoList = [];
    int index = indexVerticeFinal;
    while (index != -1) {
      caminhoList.add(vertices[index]);
      index = anteriores[index];
    }
    return caminhoList.reversed.toList();
  }

  String caminhoString() {
    return _getCaminho().join(' -> ');
  }

  List<String> caminhoList() {
    return _getCaminho();
  }

  double getDistanciaOf(String vertice) {
    return distancias[vertices.indexOf(vertice)];
  }

  @override
  String toString() {
    return "Vertices: $vertices | Anteriores: $anteriores \nCaminho: ${caminhoString()} | Distancia: ${distancias[indexVerticeFinal]}";
  }
}
