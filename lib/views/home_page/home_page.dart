import 'package:app_ui/app_ui.dart';
import 'package:city_to_city_pe/model/constants.dart';
import 'package:city_to_city_pe/model/dijkstra_result.dart';
import 'package:city_to_city_pe/model/grafo_matriz.dart';
import 'package:city_to_city_pe/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  String selectedCityPartida = '';
  String selectedCityDestino = '';

  late List<DropdownMenuItem<String>> dropdownItems;
  late GrafoMatriz matriz;

  DijkstraResult? result;
  late Animation<double> animationTitle;
  late Animation<double> animationSearch;

  late Animation<double> animationResult;
  late AnimationController _animationController;
  late AnimationController _animationControllerResult;

  @override
  void initState() {
    cidades.sort();
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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animationControllerResult = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    animationTitle = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeInOut)));
    animationSearch = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.7, 1, curve: Curves.easeInOut)));
    animationResult = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationControllerResult,
        curve: const Interval(0, 1, curve: Curves.easeInOut)));
    _animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Provider.of<ThemeProvider>(context).isDarkMode
                    ? Colors.black54
                    : Colors.white54,
                BlendMode.darken,
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) => AnimatedBuilder(
                    animation: animationTitle,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -200.00 + animationTitle.value * 200),
                        child: child,
                      );
                    },
                    child: FadeTransition(
                      opacity: animationTitle,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: themeProvider.isDarkMode
                            ? AppColors.black54
                            : AppColors.white.withOpacity(0.54),
                        width: double.infinity,
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Opacity(
                              opacity: 0,
                              child: IconButton(
                                icon: const Icon(Icons.brightness_6),
                                onPressed: () {},
                              ),
                            ),
                            Text(
                              'City to City'.toUpperCase(),
                              style: AppTextStyle.headline6.copyWith(
                                  color: themeProvider.isDarkMode
                                      ? AppColors.white
                                      : AppColors.black),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.brightness_6,
                              ),
                              onPressed: () {
                                themeProvider.toggleTheme();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                        animation: animationSearch,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(
                                -200.00 + animationSearch.value * 200, 0),
                            child: Opacity(
                              opacity: animationSearch.value,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
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
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: selectedCityPartida
                                                    .isNotEmpty &&
                                                selectedCityDestino.isNotEmpty
                                            ? () {
                                                if (_animationControllerResult
                                                        .value ==
                                                    1) {
                                                  _animationControllerResult
                                                      .reverse()
                                                      .then((value) {
                                                    setState(() {
                                                      result = matriz.dijkstra(
                                                          selectedCityPartida,
                                                          selectedCityDestino);
                                                    });
                                                    _animationControllerResult
                                                        .forward();
                                                  });
                                                } else {
                                                  setState(() {
                                                    result = matriz.dijkstra(
                                                        selectedCityPartida,
                                                        selectedCityDestino);
                                                  });
                                                  _animationControllerResult
                                                      .forward();
                                                }
                                              }
                                            : null,
                                        child: const Text(
                                          'Calcular',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
                Expanded(
                  child: AnimatedBuilder(
                      animation: animationResult,
                      builder: (context, child) {
                        return Transform.translate(
                          offset:
                              Offset(0, 200.00 - animationResult.value * 200),
                          child: FadeTransition(
                            opacity: animationResult,
                            child: Container(
                              margin: const EdgeInsets.only(top: 16),
                              width: 300,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                width: 300,
                                decoration: BoxDecoration(
                                  color: result != null
                                      ? Theme.of(context)
                                          .scaffoldBackgroundColor
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
                                          color: AppColors.secondary,
                                        ),
                                        beforeLineStyle: const LineStyle(
                                          color: AppColors.secondary,
                                        ),
                                        lineXY: 0.1,
                                        isFirst: index == 0,
                                        isLast: index ==
                                            result!.caminhoList().length - 1,
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
                            ),
                          ),
                        );
                      }),
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
