import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'configuracion.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  bool tieneConfig = prefs.containsKey('tema');
  runApp(MyApp(inicial: tieneConfig ? const HomePage() : const ConfiguracionPage()));
}

class MyApp extends StatelessWidget {
  final Widget inicial;
  const MyApp({super.key, required this.inicial});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preferencias Compartidas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      themeMode: ThemeMode.system,
      home: inicial,
    );
  }
}
