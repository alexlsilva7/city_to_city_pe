// ignore_for_file: public_member_api_docs, sort_constructors_first
class AlgoritimoDeKruskalResult {
  List<Set> conjuntos;
  double pesoArvore;
  List<String> arvore;

  AlgoritimoDeKruskalResult({
    required this.conjuntos,
    required this.pesoArvore,
    required this.arvore,
  });

  @override
  String toString() {
    return 'AlgoritimoDeKruskalResult(conjuntos: $conjuntos, pesoArvore: $pesoArvore, arvore: $arvore)';
  }
}
