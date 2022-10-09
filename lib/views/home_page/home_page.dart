import 'package:city_to_city_pe/model/constants.dart';
import 'package:city_to_city_pe/model/dijkstra_result.dart';
import 'package:city_to_city_pe/model/grafo_matriz.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCityPartida = '';
  String selectedCityDestino = '';

  late List<DropdownMenuItem<String>> dropdownItems;
  late GrafoMatriz matriz;

  DijkstraResult? result;

  @override
  void initState() {
    dropdownItems = cidades
        .map((e) => DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ))
        .toList();

    matriz = GrafoMatriz(vertices: cidades);
    for (var list in ligacoesCidade) {
      matriz.addAresta(list[0], list[1], double.parse(list[2].toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff647DEE),
            Color(0xff7F53AC),
          ],
        ),
      ),
      child: Scaffold(
        // By defaut, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      // Cidade Partida
                      DropdownButtonFormField<String>(
                        items: dropdownItems,
                        onChanged: (value) {
                          setState(() {
                            selectedCityPartida = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Cidade Partida',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Cidade Destino

                      DropdownButtonFormField<String>(
                        items: dropdownItems,
                        onChanged: (value) {
                          setState(() {
                            selectedCityDestino = value!;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Cidade Destino',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Botão Calcular
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: selectedCityPartida.isNotEmpty &&
                                  selectedCityDestino.isNotEmpty
                              ? () {
                                  setState(() {
                                    result = matriz.dijkstra(
                                        selectedCityPartida,
                                        selectedCityDestino);
                                  });
                                }
                              : null,
                          child: const Text('Calcular'),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            if (result != null)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      'Caminho: ${result?.caminhoString()}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Distância: ${result?.distancias[result!.indexVerticeFinal]}',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
