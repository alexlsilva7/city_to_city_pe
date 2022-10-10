import 'package:city_to_city_pe/model/constants.dart';
import 'package:city_to_city_pe/model/dijkstra_result.dart';
import 'package:city_to_city_pe/model/grafo_matriz.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

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
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            // By defaut, Scaffold background is white
            // Set its value to transparent
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: 300,
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
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
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 16),
                    width: 300,
                    child: ListView(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          width: 300,
                          decoration: BoxDecoration(
                            color: result != null
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 200),
                            crossFadeState: result != null
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                            firstChild: const Text(''),
                            secondChild: ListView.builder(
                              shrinkWrap: true,
                              itemCount: result != null
                                  ? result!.caminhoList().length
                                  : 0,
                              itemBuilder: (context, index) {
                                return TimelineTile(
                                  alignment: TimelineAlign.manual,
                                  indicatorStyle: IndicatorStyle(
                                    width: 20,
                                    height: 20,
                                    indicator: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  afterLineStyle: const LineStyle(
                                    color: Colors.blue,
                                  ),
                                  beforeLineStyle: const LineStyle(
                                    color: Colors.blue,
                                  ),
                                  lineXY: 0.1,
                                  isFirst: index == 0,
                                  isLast:
                                      index == result!.caminhoList().length - 1,
                                  endChild: Container(
                                    constraints: const BoxConstraints(
                                        minHeight: 40, maxHeight: 50),
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            result!.caminhoList()[index],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                          Text(
                                            '${result!.getDistanciaOf(result!.caminhoList()[index])} km',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
