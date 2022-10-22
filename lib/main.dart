import 'package:app_ui/app_ui.dart';
import 'package:city_to_city_pe/provider/theme_provider.dart';
import 'package:city_to_city_pe/views/home_page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, theme, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'City to City',
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: theme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomePage(),
        ),
      ),
    );
  }
}
